//
//  TempDetailViewController.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BaseViewController.h"
#import "ScannerDelegate.h"
#import "SDKHealthMoniter.h"

@interface TempDetailViewController : BaseViewController<CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate,sdkHealthMoniterDelegate>

@property (nonatomic, assign) NSInteger scantype;
@property (strong, nonatomic) SDKHealthMoniter *linktopManager;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;


@end
