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
#import "Utility.h"
#import "CBPeripheral+category.h"

@interface ScannerViewController (){
    Scan_type _scantype;
}

/*!
 * List of the peripherals shown on the table view. Peripheral are added to this list when it's discovered.
 * Only peripherals with bridgeServiceUUID in the advertisement packets are being displayed.
 */
@property (strong, nonatomic) NSMutableArray *peripherals;



/*!
 * The timer is used to periodically reload table
 */
@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic)  UIView *emptyView;



- (void)timerFireMethod:(NSTimer *)timer;

@end

@implementation ScannerViewController
@synthesize bluetoothManager;
@synthesize devicesTable;
@synthesize emptyView;
@synthesize filterUUID;
@synthesize peripherals;
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initLeftBarButtonItem];

    
    peripherals = [[NSMutableArray alloc]init];

    
    devicesTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCR_W, SCR_H)];
    devicesTable.delegate=self;
    devicesTable.dataSource=self;
    [devicesTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setExtraCellLineHidden:devicesTable];
    devicesTable.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:devicesTable];
    devicesTable.delegate = self;
    devicesTable.dataSource = self;
    
    // Display an activity indicator in the Navigation bar
    UIActivityIndicatorView* uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
    
    // We want the scanner to scan with dupliate keys (to refresh RRSI every second) so it has to be done using non-main queue

    
    

}

- (void)setScan_Type:(Scan_type)scan_Type{
    _scantype = scan_Type;
    switch (scan_Type) {
        case scan_Checkme:
        {
            dispatch_queue_t centralQueue = dispatch_queue_create("ios.checkme", DISPATCH_QUEUE_SERIAL);
            bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
            bluetoothManager.delegate=self;
        }
            break;
        case scan_linkTop:
        {
            self.sdkHealth = [[SDKHealthMoniter alloc]init];
            self.sdkHealth.sdkHealthMoniterdelegate=self;
            
            //搜索linktop蓝牙设备
            [self.sdkHealth scanStart];
        }
            break;
        case scan_Health:
        {
            dispatch_queue_t centralQueue = dispatch_queue_create("ios.health", DISPATCH_QUEUE_SERIAL);
            bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
            bluetoothManager.delegate=self;
        }
            break;
        default:
            break;
    }
    
}
#pragma mark --sdkHealthMoniter的代理

-(void)didScanedPeripherals:(NSMutableArray *)foundPeripherals
{
    for (NSDictionary *per in foundPeripherals) {
        if (![peripherals containsObject:per]) {
            [peripherals addObject:per];
        }
    }
   
    [devicesTable reloadData];
    
}

-(void)didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSLog(@"Connection Successful");
    [self dismissAnimated:NO];
    [self performSelector:@selector(pop) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
    
}

-(void)pop{
    [self showToast:@"配对成功"];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)disconnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"DisconnectPeripheral");
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillDisappear:animated];
    [self scanForPeripherals:NO];
}

- (void)didCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
//        [self getConnectedPeripherals];
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
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
            if (filterUUID != nil)
            {
                [bluetoothManager scanForPeripheralsWithServices:nil options:options];
            }
            else
            {
                [bluetoothManager scanForPeripheralsWithServices:nil options:options];
            }
            
            
            //记录目前是扫描状态
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
//        emptyView.hidden = YES;
        [devicesTable reloadData];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    if (peripheral == nil||peripheral.identifier == nil/*||peripheral.name == nil*/)
    {
        return;
    }
//    if ([[advertisementData objectForKey:CBAdvertisementDataIsConnectable] boolValue])
//    {
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
//    }
}

#pragma mark Table View delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [bluetoothManager stopScan];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Call delegate method
    switch (_scantype) {
        case scan_Checkme:
        {
            if ([self.delegate respondsToSelector:@selector(centralManager:didPeripheralSelected:)]) {
                
                [self.delegate centralManager:bluetoothManager didPeripheralSelected:[[peripherals objectAtIndex:indexPath.row] peripheral]];
            }
           
        }
            break;
        case scan_linkTop:
        {
            NSDictionary *dic = [peripherals objectAtIndex:indexPath.row];
            //外设
            CBPeripheral * peripheral = [dic objectForKey:@"peripheral"];
            if (peripheral)
            {
                [self showTextOnlyHud:2 text:@"正在配对.."];

                //连接蓝牙设备
                [self.sdkHealth connectBlueTooth:peripheral];
                //停止扫描蓝牙
                [self.sdkHealth scanStop];
            }
            if ([self.delegate respondsToSelector:@selector(linktopManger:didperiphralSelected:)]) {
                [self.delegate linktopManger:self.sdkHealth didperiphralSelected:dic];
            }
        }
            break;
        case scan_Health:
        {
            if ([self.delegate respondsToSelector:@selector(centralManager:didPeripheralSelected:)]) {
                
                [self.delegate centralManager:bluetoothManager didPeripheralSelected:[[peripherals objectAtIndex:indexPath.row] peripheral]];
            }
        }
            break;
        default:
            break;
    }

}


#pragma mark Table View Data Source delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *NailCellIdentifier = @"NailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NailCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NailCellIdentifier];
    }
    
    // Update sensor name
    
    switch (_scantype) {
        case scan_Checkme:
        {
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
            break;
        case scan_linkTop:
        {
            NSDictionary *dic = [peripherals objectAtIndex:indexPath.row];
            //外设
            if ([dic isKindOfClass:[NSDictionary class]])
            {
                cell.textLabel.text = [dic objectForKey:@"LocalName"];
            }
            CBPeripheral *per = [dic objectForKey:@"peripheral"] ;
            cell.imageView.image = [self getRSSIImage:per.RSSI];
            return cell;

        }
            break;
        case scan_Health:
        {
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
            break;
        default:
            break;
    }
    return nil;
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
