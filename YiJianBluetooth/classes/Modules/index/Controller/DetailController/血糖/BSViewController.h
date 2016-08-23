//
//  BSViewController.h
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/8/17.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerDelegate.h"
#import "SDKHealthMoniter.h"
@interface BSViewController : BaseViewController<CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate>


@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (strong, nonatomic) SDKHealthMoniter *linktopManager;

@property (nonatomic, assign) NSInteger scantype;

@end
