/*
 * Copyright (c) 2015, Nordic Semiconductor
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ScannerViewController.h"
#import "ScannedPeripheral.h"
//#import "Utility.h"


#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

NSString * const dfuServiceUUIDString  = @"00001530-1212-EFDE-1523-785FEABCD123";
NSString * const ANCSServiceUUIDString = @"7905F431-B5CE-4E99-A40F-4B1E122D00D0";
@interface ScannerViewController ()

/*!
 * List of the peripherals shown on the table view. Peripheral are added to this list when it's discovered.
 * Only peripherals with bridgeServiceUUID in the advertisement packets are being displayed.
 */
@property (strong, nonatomic) NSMutableArray *peripherals;
/*!
 * The timer is used to periodically reload table
 */
@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

- (void)timerFireMethod:(NSTimer *)timer;




@end

@implementation ScannerViewController
@synthesize bluetoothManager;
@synthesize emptyView;
@synthesize filterUUID;
@synthesize peripherals;
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"扫描设备";
    self.view.backgroundColor = [UIColor whiteColor];
    peripherals = [NSMutableArray arrayWithCapacity:8];
    self.devicesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:(UITableViewStyleGrouped)];
    self.devicesTable.delegate = self;
    self.devicesTable.dataSource = self;
    
    // Display an activity indicator in the Navigation bar
    UIActivityIndicatorView* uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:(UIBarButtonItemStylePlain) target:self action:@selector(BackAc)];
    // We want the scanner to scan with dupliate keys (to refresh RRSI every second) so it has to be done using non-main queue
    dispatch_queue_t centralQueue = dispatch_queue_create("no.nordicsemi.ios.nrftoolbox", DISPATCH_QUEUE_SERIAL);
    bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
}
-(void)BackAc{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillDisappear:animated];
    [self scanForPeripherals:NO];
}



- (void)getConnectedPeripherals
{
    if (filterUUID != nil)
    {
        NSArray *connectedPeripherals = [bluetoothManager retrieveConnectedPeripheralsWithServices:@[filterUUID]];
        
        for (CBPeripheral *connectedPeripheral in connectedPeripherals)
        {
            [self addConnectedPeripheral:connectedPeripheral];
        }
    }
    else
    {
        CBUUID *dfuServiceUUID = [CBUUID UUIDWithString:dfuServiceUUIDString];
        CBUUID *ancsServiceUUID = [CBUUID UUIDWithString:ANCSServiceUUIDString];
        NSArray *connectedPeripherals = [bluetoothManager retrieveConnectedPeripheralsWithServices:@[dfuServiceUUID, ancsServiceUUID]];
        
        for (CBPeripheral *connectedPeripheral in connectedPeripherals)
        {
            [self addConnectedPeripheral:connectedPeripheral];
        }
    }
}

- (void) addConnectedPeripheral:(CBPeripheral *)peripheral
{
    ScannedPeripheral* sensor = [ScannedPeripheral initWithPeripheral:peripheral rssi:0 isPeripheralConnected:YES];
    [peripherals addObject:sensor];
}

#pragma mark Central Manager delegate methods

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        //TODO Retrieve already connected/paired devices
        [self getConnectedPeripherals];
        [self scanForPeripherals:YES];
    }
}

/*!
 * @brief Starts scanning for peripherals with rscServiceUUID
 * @param enable If YES, this method will enable scanning for bridge devices, if NO it will stop scanning
 * @return 0 if success, -1 if Bluetooth Manager is not in CBCentralManagerStatePoweredOn state.
 */
- (int) scanForPeripherals:(BOOL)enable
{
    if (bluetoothManager.state != CBCentralManagerStatePoweredOn)
    {
        return -1;
    }
    
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enable)
        {
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
            if (filterUUID != nil)
            {
                [bluetoothManager scanForPeripheralsWithServices:@[ filterUUID ] options:options];
            }
            else
            {
                [bluetoothManager scanForPeripheralsWithServices:nil options:options];
            }
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        }
        else
        {
            [timer invalidate];
            timer = nil;
            
            [bluetoothManager stopScan];
        }
    });
    return 0;
}

/*!
 * @brief This method is called periodically by the timer. It refreshes the devices list. Updates from Central Manager comes to fast and it's hard to select a device if refreshed from there.
 * @param timer the timer that has called the method
 */
- (void)timerFireMethod:(NSTimer *)timer
{
    if ([peripherals count] > 0)
    {
        emptyView.hidden = YES;
        [self.devicesTable reloadData];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    if ([[advertisementData objectForKey:CBAdvertisementDataIsConnectable] boolValue])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Add the sensor to the list and reload deta set
            ScannedPeripheral* sensor = [ScannedPeripheral initWithPeripheral:peripheral rssi:RSSI.intValue isPeripheralConnected:NO];
            if (![peripherals containsObject:sensor])
            {
                [peripherals addObject:sensor];
            }
            else
            {
                sensor = [peripherals objectAtIndex:[peripherals indexOfObject:sensor]];
                sensor.RSSI = RSSI.intValue;
            }
        });
    }
}

#pragma mark Table View delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [bluetoothManager stopScan];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Call delegate method
    [self.delegate centralManager:bluetoothManager didPeripheralSelected:[[peripherals objectAtIndex:indexPath.row] peripheral]];
}

#pragma mark Table View Data Source delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Update sensor name
    ScannedPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    cell.textLabel.text = [peripheral name];
    if (peripheral.isConnected)
    {
        cell.imageView.image = [UIImage imageNamed:@"Connected"];
    }
    else
    {
        cell.imageView.image = [self getRSSIImage:peripheral.RSSI];
    }
    return cell;
}

-(UIImage *) getRSSIImage:(int)rssi {
    // Update RSSI indicator
    UIImage* image;
    if (rssi < -90)
    {
        image = [UIImage imageNamed: @"Signal_0"];
    }
    else if (rssi < -70)
    {
        image = [UIImage imageNamed: @"Signal_1"];
    }
    else if (rssi < -50)
    {
        image = [UIImage imageNamed: @"Signal_2"];
    }
    else
    {
        image = [UIImage imageNamed: @"Signal_3"];
    }
    return image;
}

@end
