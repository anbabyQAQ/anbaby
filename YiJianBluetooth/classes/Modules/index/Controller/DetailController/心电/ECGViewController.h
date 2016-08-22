//
//  ECGViewController.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerDelegate.h"
#import "SDKHealthMoniter.h"

@interface ECGViewController : BaseViewController<CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate>


@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@property (strong, nonatomic) SDKHealthMoniter *linktopManager;

@property (nonatomic, assign) NSInteger scantype;

@end
