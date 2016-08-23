//
//  ECGDetailViewController.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BaseViewController.h"
#import "ScannerDelegate.h"
#import "SDKHealthMoniter.h"
#import "LeadPlayer.h"

@interface ECGDetailViewController : BaseViewController<CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate,sdkHealthMoniterDelegate>{
    
    NSMutableArray *leads, *buffer;
    NSTimer *drawingTimer, *readDataTimer, *recordingTimer, *popDataTimer, *playSoundTimer;
    
    UIImage *recordingImage;
    
    int second;
    BOOL stopTheTimer, autoStart, DEMO, monitoring;
    
    UIButton *btnStart, *btnStop, *photoView;
    
    UIImage *screenShot;
    
    int layoutScale;  // 0: 3x4   1: 2x6   2: 1x12
    int startRecordingIndex, endRecordingIndex, HR;
    
    NSString *now;
    BOOL liveMode;
    UILabel *labelRate, *labelProfileId, *labelProfileName, *labelMsg;
    UIBarButtonItem *statusInfo, *btnDismiss, *btnRefresh;
    
    
    int countOfPointsInQueue, countOfRecordingPoints;
    int currentDrawingPoint, bufferCount;
    
    
    LeadPlayer *firstLead;
    
    int lastHR;
    int newBornMode, errorCount;
}

@property (nonatomic, strong) NSMutableArray *leads, *buffer;
@property (nonatomic, strong)  UIButton *btnStart, *photoView, *btnRecord;
@property (nonatomic, strong)  UIView *vwProfile, *vwMonitor;
@property (nonatomic) BOOL liveMode, DEMO;
@property (nonatomic, strong)  UILabel *labelRate, *labelProfileId, *labelProfileName, *labelMsg;
@property (nonatomic, strong)  UIBarButtonItem *statusInfo, *btnDismiss, *btnRefresh;
@property (nonatomic) int startRecordingIndex, HR, newBornMode;
@property (nonatomic) BOOL stopTheTimer;
@property (nonatomic, strong)  UILabel *lbDevice;





@property (nonatomic, assign) NSInteger scantype;
@property (strong, nonatomic) SDKHealthMoniter *linktopManager;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;

@end
