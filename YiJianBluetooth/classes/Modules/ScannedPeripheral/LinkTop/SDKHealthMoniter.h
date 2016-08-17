//
//  SDKHealthMoniter.h
//  SDKHealthMoniter
//
//  Created by xxoo on 15-6-15.
//  Copyright (c) 2015年 beibei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


typedef NS_ENUM(NSUInteger, MSGTYPE) {
    MSGTYPE_PAPERISREADY,
    MSGTYPE_PAPERISUSED,
    MSGTYPE_BLOODINDETECTED,
    MSGTYPE_TIMEOUT,
    MSGTYPE_BLOODDETECTEDCOMPLATED,
    MSGTYPE_PAPEROUT
};

@protocol sdkHealthMoniterDelegate <NSObject>

@required
/**
 *  @discussion Get temperature results
 *
 *  @param temperature temperature value
 */
-(void)receiveThermometerData:(double)temperature;


/**
 *  @discussion  Get Oximetry results
 *
 *  @param Oximetry Oximetry value
 *  @param heartRate heartRate value
 */
-(void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate;




/**
 *  @discussion Get BloodPressure results
 *
 *  @param BloodPressure Systolic_pressure value Diastolic_pressure value
 *          Heart_beat value
 */
-(void)receiveBloodPressure:(int)Systolic_pressure andDiastolic_pressure:(int)Diastolic_pressure andHeart_beat:(int)Heart_beat;

/**
 *  @discussion
 *
 *  @param msgtype msgType ENUM
 *  @param row     if row!=nil , according to this param ,invoke method getBloodSugarInRow in this object(SDKHealthMoniter) to transform blood sugar
 */
-(void) receiveBloodSugar:(MSGTYPE) msgtype andRow:(NSNumber*) row;



/**
 *  @discussion Get ECG results
 *
 *  @param ECGData rrMax value rrMin value HRV value
 *                  mood value smoothWave LineData heartRate Value
 */
-(void)receiveECGDataRRmax:(int)rrMax;

-(void)receiveECGDataRRMin:(int)rrMin;

-(void)receiveECGDataHRV:(int)hrv;

-(void)receiveECGDataMood:(int)mood;

-(void)receiveECGDataSmoothedWave:(int)smoothedWave;

-(void)receiveECGDataHeartRate:(int)heartRate;


/*!
 *  @method didScanedPeripherals:(NSMutableArray  *)foundPeripherals
 *
 *  @param foundPeripherals           A <code>foundPeripherals</code> object.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery
 *
 */
- (void) didScanedPeripherals:(NSMutableArray  *)foundPeripherals;





/*!
 *  @method didConnectPeripheral:(CBPeripheral *)peripheral
 *
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by @link UartLib:ConnectPeripheral: @/link has succeeded.
 *
 */
- (void) didConnectPeripheral:(CBPeripheral *)peripheral;




/*!
 *  @method disconnectPeripheral:(CBPeripheral *)peripheral
 *
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a disconnection initiated by @link UartLib:ConnectPeripheral: @/link has disconnect.
 *
 */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;


@optional
/*!
 *  @method blueToothAbnormalDisconnect
 *
 
 *
 *  @discussion         This method is invoked when blueTooth
 *  abnormal dicconnect
 */
-(void)blueToothAbnormalDisconnect;


/*!
 *  @method bloodPressureAbnormal
 *
 *  @param message   The <code>str</code> that abnormal message.
 *
 *  @discussion         This method is invoked when bloodPressure
 *  abnormal dicconnect
 */
-(void)bloodPressureAbnormal:(NSString *)message;

@end


@interface SDKHealthMoniter : NSObject


/*!
 *  @method startThermometerTest
 *
 *  @discussion         Start temperature test for device.
 *
 */
-(void)startThermometerTest;



/*!
 *  @method endThermometerTest
 *
 *  @discussion         end temperature test for device.
 *
 */
-(void)endThermometerTest;


/*!
 *  @method startOximetryTest
 *
 *  @discussion         Start Oximetry test for device.
 *
 */
-(void)startOximetryTest;


/*!
 *  @method endOximetryTest
 *
 *  @discussion         end Oximetry test for device.
 *
 */
-(void)endOximetryTest;



/*!
 *  @method startBloodPressure
 *
 *  @discussion         Start BloodPressure test for device.
 *
 */
-(void)startBloodPressure;


/*!
 *  @method endBloodPressure
 *
 *  @discussion         end BloodPressure test for device.
 *
 */
-(void)endBloodPressure;


/*!
 *  @method startECG
 *
 *  @discussion         Start ECG test for device.
 *
 */
-(void)startECG;



/*!
 *  @method endECG
 *
 *  @discussion         end ECG test for device.
 *
 */
-(void)endECG;


/*!
 *  @method startBloodSugar
 *
 *  @discussion         start BloodSugar test for device.
 *
 */
-(void) startBloodSugar;


/*!
 *  @method endBloodSugar
 *
 *  @discussion         end  BloodSugar test for device.
 *
 */
-(void) endBloodSugar;

/*!
 *  @method getBloodSugarInRow
 *
 *  @discussion         according to paper and receiveBloodSugar row  to get blood sugar
 *
 */
-(double) getBloodSugarInRow:(int) row andPaperType:(NSString*) paperType;

/*!
 *  @method getAllPaperType
 *
 *  @discussion     getAllPaperType in database.
 *
 */
-(NSArray*) getAllPaperType;


//SDKHealthMoniter delegate
@property(weak,nonatomic)id<sdkHealthMoniterDelegate>sdkHealthMoniterdelegate;


/*!
 *  @method scanStart
 *
 *  @discussion         Start scanning for peripherals.
 *
 */
-(void)scanStart;




/*!
 *  @method scanStop
 *
 *  @discussion         Stops scanning for peripherals.
 *
 */
-(void)scanStop;



/*!
 *  @method connectPeripheral:(CBPeripheral*)peripheral
 *
 *  @param peripheral   The <code>CBPeripheral</code> to be connected.
 *
 *  @discussion         Initiates a connection to <i>peripheral</i>. Connection attempts never time out and, depending on the outcome, will result in a call to either @link UartLib:didConnectPeripheral: @/link or
 @link UartLib:didDisconnectPeripheral:error: @/link.
 *                      Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via @link cancelPeripheralConnection @/link.
 *
 *
 */
-(void)connectBlueTooth:(CBPeripheral*)peripheral;


/*!
 *  @method disconnectPeripheral:(CBPeripheral*)peripheral
 *
 *  @param peripheral   A <code>CBPeripheral</code>.
 *
 *  @discussion         Cancels an active or pending connection to <i>peripheral</i>. Note that this is non-blocking, and any <code>CBPeripheral</code>
 *                      commands that are still pending to <i>peripheral</i> may or may not complete.
 *
 */
-(void)disconnectBlueTooth:(CBPeripheral*)peripheral;




@end
