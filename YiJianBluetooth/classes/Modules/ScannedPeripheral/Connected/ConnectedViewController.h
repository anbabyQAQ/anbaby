//
//  ConnectedViewController.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/17.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#include "ScannerDelegate.h"
#import "SDKHealthMoniter.h"

@interface ConnectedViewController : BaseViewController<CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource,CBPeripheralDelegate,sdkHealthMoniterDelegate>

@property (strong, nonatomic)  UITableView *devicesTable;


@end
