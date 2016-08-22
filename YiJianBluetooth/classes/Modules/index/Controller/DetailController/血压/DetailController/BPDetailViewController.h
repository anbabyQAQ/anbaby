//
//  BPDetailViewController.h
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/8/18.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerDelegate.h"
#import "SDKHealthMoniter.h"

@interface BPDetailViewController : BaseViewController<CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate,sdkHealthMoniterDelegate>

@property (nonatomic, assign) NSInteger scantype;
@property (strong, nonatomic) SDKHealthMoniter *linktopManager;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@end
