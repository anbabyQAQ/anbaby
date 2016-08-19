//
//  TempViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/8.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TempViewController.h"
#import "MAThermometer.h"
#import "TempDetailViewController.h"
#import "TempChartViewController.h"
#import "ScannerViewController.h"
#import "ConnectedViewController.h"

@interface TempViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}
@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;
@property (nonatomic, strong) UIView   *temp_view;

@property (nonatomic, strong) UITableView *tempTableview;

@property (nonatomic, strong) MAThermometer * thermometer1;


@property (strong, nonatomic) CBPeripheral* connectedPeripheral;


//设备数组
@property (nonatomic, strong) NSMutableArray *peripheral_arr;


@property (nonatomic, strong) NSDictionary *linktopPeripheral;

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"体温";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTempLayout];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];

//    MyCustomButton *mapbutton = [MyCustomButton buttonWithType:UIButtonTypeSystem];
//    [mapbutton setFrame:CGRectMake(0, 0, 60 , 30)];
//    [mapbutton setTitle:@"连接设备" forState:(UIControlStateNormal)];
//    [mapbutton setTintColor:[UIColor blueColor]];
//    [mapbutton addTarget:self action:@selector(setRightBtn) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:mapbutton];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:view];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self initRightBarButtonItem];
    [self initLeftBarButtonItem];

    [self addtableview];
    
}

- (void)backToSuper{
    CBPeripheral *per = [_linktopPeripheral objectForKey:@"peripheral"];
    if (per)
    {
        [_linktopManager disconnectBlueTooth:per];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initRightBarButtonItem {
    MyCustomButton *button = [MyCustomButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 44)];
    UIImage *image = [UIImage imageNamed:@"bag"];
    [button setImage:image forState:UIControlStateNormal];
    [button setMyButtonImageFrame:CGRectMake(35, 12, image.size.width-10, image.size.height-10)];
    [button addTarget:self action:@selector(setRightBtn)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = leftBtn;
}


- (void)addtableview{
    _peripheral_arr = [[NSMutableArray alloc] initWithObjects:@"Checkme",@"linkTop",@"Health", nil];

    _tempTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _peripheral_arr.count*40)];
    _tempTableview.delegate=self;
    _tempTableview.dataSource=self;
    [_tempTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setExtraCellLineHidden:_tempTableview];
    _tempTableview.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:_tempTableview];
    
    _tempTableview.hidden= YES;
    
}

-(void)setRightBtn{
    
    _tempTableview.hidden = !_tempTableview.hidden;
    
}

- (void) initTempLayout{
    self.temp_lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    self.temp_lab.textAlignment=NSTextAlignmentLeft;
    self.temp_lab.text=@"体温";
    self.temp_lab.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.temp_lab.textColor = [UIColor blackColor];
    [self.view addSubview: self.temp_lab];
    
    
    _temp_view = [[UIView alloc] initWithFrame:CGRectMake(SCR_W/2-30, 50, 60, 150)];
    _temp_view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.temp_view.layer.masksToBounds = YES;
    self.temp_view.layer.cornerRadius = 6.0;
    self.temp_view.layer.borderWidth = 1.0;
    self.temp_view.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_temp_view];

    
    _thermometer1 = [[MAThermometer alloc] initWithFrame:CGRectMake(10, 0, 40, 150)];
    [_thermometer1 setMaxValue:42];
    [_thermometer1 setMinValue:30];
    _thermometer1.glassEffect = YES;
    _thermometer1.arrayColors = @[UIColorFromRGB(0xc62828)];
    int x = arc4random() % 8+35;
    int y = arc4random()%10;
    _thermometer1.curValue = x+y*0.1;
    [_temp_view addSubview:_thermometer1];
    
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(220, 150, 80, 20)];
    temp.textAlignment=NSTextAlignmentLeft;
    temp.text=[NSString stringWithFormat:@"_ _℃"];
    temp.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    temp.textColor = [UIColor grayColor];
    [self.view addSubview: temp];
    
    
    _startTest_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startTest_btn.frame = CGRectMake(20, SCR_H-NAVIGATION_HEIGHT-70, SCR_W-40, 50);
    [_startTest_btn addTarget:self action:@selector(setRightBtn) forControlEvents:(UIControlEventTouchUpInside)];
    _startTest_btn.backgroundColor = UIColorFromRGB(0xc62828);
    [_startTest_btn setTitle:@"连接设备" forState:(UIControlStateNormal)];
    [_startTest_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.startTest_btn.layer.masksToBounds = YES;
    self.startTest_btn.layer.cornerRadius = 6.0;
    self.startTest_btn.layer.borderWidth = 1.0;
    self.startTest_btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_startTest_btn];
    
}

- (void) centralManager:(CBCentralManager*) manager didPeripheralSelected:(CBPeripheral*) peripheral{
    
    
    _bluetoothManager = manager;
    _bluetoothManager.delegate = self;
    
    // The sensor has been selected, connect to it
    peripheral.delegate = self;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
    [_bluetoothManager connectPeripheral:peripheral options:options];
}

- (void)linktopManger:(SDKHealthMoniter *)manager didperiphralSelected:(NSDictionary *)dic_peripheral{
    _scantype=scan_linkTop;
    _linktopPeripheral = dic_peripheral;
    
    _linktopManager = manager;
    if (manager) {
        [_startTest_btn respondsToSelector:@selector(setRightBtn)];
        [_startTest_btn addTarget:self action:@selector(clickbtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [_startTest_btn setTitle:@"开始测体温" forState:(UIControlStateNormal)];
    }
    

}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
   

    
    // Peripheral has connected. Discover required services
    _connectedPeripheral = peripheral;
    _connectedPeripheral.delegate=self;
    //    [peripheral discoverServices:@[htsServiceUUID, batteryServiceUUID]];
    [peripheral discoverServices:nil];
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
//        [AppUtilities showAlert:@"Error" alertMessage:@"Connecting to the peripheral failed. Try again"];
//        [connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
//        connectedPeripheral = nil;
//        
//        [self clearUI];
    });
    
    //连接失败提示 。
}


#pragma mark Peripheral delegate methods

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
        [_bluetoothManager cancelPeripheralConnection:_connectedPeripheral];
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        // Discovers the characteristics for a given service
        NSLog(@"%@",service.UUID);
            [_connectedPeripheral discoverCharacteristics:nil forService:service];
      
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Characteristics for one of those services has been found
//    if ([service.UUID isEqual:htsServiceUUID])
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
//            if ([characteristic.UUID isEqual:htsMeasurementCharacteristicUUID])
//            {
                // Enable notification on data characteristic
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                break;
//            }
        }
    }
//    }
 
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSString *newString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"Receive -> %@",newString);
    
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        // Decode the characteristic data
        //        NSData *data = characteristic.value;
        //        uint8_t *array = (uint8_t*) data.bytes;
        
        if (error==nil) {
            //调用下面的方法后 会调用到代理的- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
            [peripheral readValueForCharacteristic:characteristic];
        }
       
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}

- (void)clickbtn:(id)sender{
    
    TempDetailViewController *detailVC = [[TempDetailViewController alloc] init];
    detailVC.linktopManager = _linktopManager;
    detailVC.bluetoothManager = _bluetoothManager;
    detailVC.scantype = self.scantype;

    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheral_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    static NSString *NailCellIdentifier = @"NailCell";
    UITableViewCell *nailcell = [tableView dequeueReusableCellWithIdentifier:NailCellIdentifier];
    if (nailcell == nil) {
        nailcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NailCellIdentifier];
    }
    nailcell.textLabel.textAlignment = NSTextAlignmentLeft;
    nailcell.textLabel.text = _peripheral_arr[indexPath.row];
    [nailcell.textLabel setFont:[UIFont systemFontOfSize:text_size_small]];
    nailcell.imageView.image = nil;
    nailcell.accessoryType = UITableViewCellAccessoryNone;
    nailcell.backgroundColor = [UIColor whiteColor];
    nailcell.alpha=1;
    return nailcell;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSInteger index = indexPath.row;
    ScannerViewController *scan = [[ScannerViewController alloc] init];
    scan.delegate = self;
    scan.scan_Type=index+1;
    
    
    _tempTableview.hidden=YES;
    [self.navigationController pushViewController:scan animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
