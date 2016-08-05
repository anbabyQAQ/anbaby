//
//  TemperatureViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TemperatureViewController.h"
#import "ScannerDelegate.h"
#import "ScannerViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CharacteristicReader.h"
@interface TemperatureViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate>
{
    CBUUID *htsServiceUUID;
    CBUUID *htsMeasurementCharacteristicUUID;
    CBUUID *batteryServiceUUID;
    CBUUID *batteryLevelCharacteristicUUID;
}

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (strong, nonatomic) CBPeripheral* connectedPeripheral;
@end


static NSString * const htsServiceUUIDString = @"00001809-0000-1000-8000-00805F9B34FB";
static NSString * const htsMeasurementCharacteristicUUIDString = @"00002A1C-0000-1000-8000-00805F9B34FB";

static NSString * const batteryServiceUUIDString = @"0000180F-0000-1000-8000-00805F9B34FB";
static NSString * const batteryLevelCharacteristicUUIDString = @"00002A19-0000-1000-8000-00805F9B34FB";
@implementation TemperatureViewController
{
    BOOL fahrenheit;
    float temperatureValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"温度";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:(UIBarButtonItemStylePlain) target:self action:@selector(BackAc)];
    
    htsServiceUUID = [CBUUID UUIDWithString:htsServiceUUIDString];
    htsMeasurementCharacteristicUUID = [CBUUID UUIDWithString:htsMeasurementCharacteristicUUIDString];
    batteryServiceUUID = [CBUUID UUIDWithString:batteryServiceUUIDString];
    batteryLevelCharacteristicUUID = [CBUUID UUIDWithString:batteryLevelCharacteristicUUIDString];
    
    
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    self.bluetoothManager.delegate = self;
    
    
    
}

-(void)BackAc{

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)lianjieButtonAction:(id)sender {
    
//   
//    if (self.connectedPeripheral != nil)
//    {
//        [self.bluetoothManager cancelPeripheralConnection:self.connectedPeripheral];
//    }
    
    
    ScannerViewController *controller = [[ScannerViewController alloc] init];
    controller.filterUUID = htsServiceUUID;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark Scanner Delegate methods

-(void)centralManager:(CBCentralManager *)manager didPeripheralSelected:(CBPeripheral *)peripheral
{
    // We may not use more than one Central Manager instance. Let's just take the one returned from Scanner View Controller
    self.bluetoothManager = manager;
    self.bluetoothManager.delegate = self;
    
    // The sensor has been selected, connect to it
    peripheral.delegate = self;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
    [self.bluetoothManager connectPeripheral:peripheral options:options];
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // TODO
        
        
    }
    else
    {
        NSLog(@"蓝牙没开，请检查蓝牙");
    }
}

#pragma mark ======链接设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
//        [deviceName setText:peripheral.name];
//        [connectButton setTitle:@"DISCONNECT" forState:UIControlStateNormal];
        //断开
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActiveBackground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Peripheral has connected. Discover required services
    self.connectedPeripheral = peripheral;
    [peripheral discoverServices:@[htsServiceUUID, batteryServiceUUID]];
}


#pragma mark ======链接蓝牙失败=========
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接到外围设备失败。再试一次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        
        //message（连接到外围设备失败。再试一次）
//        [AppUtilities showAlert:@"Error" alertMessage:@"Connecting to the peripheral failed. Try again"];
//        [connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        self.connectedPeripheral = nil;
        
        [self clearUI];
    });
}


#pragma mark === 连接失败
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
//        [connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
//        if ([AppUtilities isApplicationStateInactiveORBackground]) {
//            [AppUtilities showBackgroundNotification:[NSString stringWithFormat:@"%@ peripheral is disconnected",peripheral.name]];
//        }
        self.connectedPeripheral = nil;
        [self clearUI];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
}

- (void) clearUI
{
//    [deviceName setText:@"DEFAULT HTM"];
//    battery.tag = 0;
//    [battery setTitle:@"n/a" forState:UIControlStateDisabled];
//    [self.temperature setText:@"-"];
//    [self.timestamp setText:@""];
//    [self.type setText:@""];
}

#pragma mark Peripheral delegate methods
#pragma mark 在这个方法中我们要查找到我们需要的服务 然后调用discoverCharacteristics方法查找我们需要的特性该discoverCharacteristics方法调用完后会调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
        [self.bluetoothManager cancelPeripheralConnection:self.connectedPeripheral];
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        // Discovers the characteristics for a given service
        if ([service.UUID isEqual:htsServiceUUID])
        {
            [self.connectedPeripheral discoverCharacteristics:@[htsMeasurementCharacteristicUUID] forService:service];
        }
        else if ([service.UUID isEqual:batteryServiceUUID])
        {
            [self.connectedPeripheral discoverCharacteristics:@[batteryLevelCharacteristicUUID] forService:service];
        }
    }
}


#pragma mark ======在这个方法中我们要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化 当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Characteristics for one of those services has been found
    if ([service.UUID isEqual:htsServiceUUID])
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            if ([characteristic.UUID isEqual:htsMeasurementCharacteristicUUID])
            {
                // Enable notification on data characteristic
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                break;
            }
        }
    }
    else if ([service.UUID isEqual:batteryServiceUUID])
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            if ([characteristic.UUID isEqual:batteryLevelCharacteristicUUID])
            {
                // Read the current battery value
                [peripheral readValueForCharacteristic:characteristic];
                break;
            }
        }
    }
}


#pragma mark =====在接收数据
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        // Decode the characteristic data
        NSData *data = characteristic.value;
        uint8_t *array = (uint8_t*) data.bytes;
        
        if ([characteristic.UUID isEqual:batteryLevelCharacteristicUUID])
        {
            uint8_t batteryLevel = [CharacteristicReader readUInt8Value:&array];
            NSString* text = [[NSString alloc] initWithFormat:@"%d%%", batteryLevel];
            //[battery setTitle:text forState:UIControlStateDisabled];
            
//            if (battery.tag == 0)
//            {
//                // If battery level notifications are available, enable them
//                if (([characteristic properties] & CBCharacteristicPropertyNotify) > 0)
//                {
//                    battery.tag = 1; // mark that we have enabled notifications
//                    
//                    // Enable notification on data characteristic
//                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//                }
//            }
        }
        else if ([characteristic.UUID isEqual:htsMeasurementCharacteristicUUID])
        {
            int flags = [CharacteristicReader readUInt8Value:&array];
            BOOL tempInFahrenheit = (flags & 0x01) > 0;
            BOOL timestampPresent = (flags & 0x02) > 0;
            BOOL typePresent = (flags & 0x04) > 0;
            
            float tempValue = [CharacteristicReader readFloatValue:&array];
            if (!tempInFahrenheit && fahrenheit)
                tempValue = tempValue * 9.0f / 5.0f + 32.0f;
            if (tempInFahrenheit && !fahrenheit)
                tempValue = (tempValue - 32.0f) * 5.0f / 9.0f;
            temperatureValue = tempValue;
            self.temperatureLabel.text = [NSString stringWithFormat:@"%.2f", tempValue];
            
            if (timestampPresent)
            {
                NSDate* date = [CharacteristicReader readDateTime:&array];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy, hh:mm"];
                NSString* dateFormattedString = [dateFormat stringFromDate:date];
                
                //self.timestamp.text = dateFormattedString;
            }
            else
            {
               // self.timestamp.text = @"Date n/a";
            }
            
            /* temperature type */
            if (typePresent)
            {
                uint8_t type = [CharacteristicReader readUInt8Value:&array];
                NSString* location = nil;
                
                switch (type)
                {
                    case 0x01:
                        location = @"Armpit";
                        break;
                    case 0x02:
                        location = @"Body - general";
                        break;
                    case 0x03:
                        location = @"Ear";
                        break;
                    case 0x04:
                        location = @"Finger";
                        break;
                    case 0x05:
                        location = @"Gastro-intenstinal Tract";
                        break;
                    case 0x06:
                        location = @"Mouth";
                        break;
                    case 0x07:
                        location = @"Rectum";
                        break;
                    case 0x08:
                        location = @"Toe";
                        break;
                    case 0x09:
                        location = @"Tympanum - ear drum";
                        break;
                    default:
                        location = @"Unknown";
                        break;
                }
                if (location)
                {
                    //self.type.text = [NSString stringWithFormat:@"Location: %@", location];
                }
            }
            else
            {
               // self.type.text = @"Location: n/a";
            }
            
//            if ([AppUtilities isApplicationStateInactiveORBackground])
//            {
//                NSString *message;
//                if (fahrenheit)
//                {
//                    message = [NSString stringWithFormat:@"New temperature reading: %.2f°F", tempValue];
//                }
//                else
//                {
//                    message = [NSString stringWithFormat:@"New temperature reading: %.2f°C", tempValue];
//                }
//                //[AppUtilities showBackgroundNotification:message];
//            }
        }
    });
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
