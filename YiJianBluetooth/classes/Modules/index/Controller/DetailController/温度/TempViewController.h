//
//  TempViewController.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/8.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BaseViewController.h"
#import "ScannerDelegate.h"
#import "SDKHealthMoniter.h"

@interface TempViewController : BaseViewController<CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate>


@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (strong, nonatomic) SDKHealthMoniter *linktopManager;

@property (nonatomic, assign) NSInteger scantype;

@end
