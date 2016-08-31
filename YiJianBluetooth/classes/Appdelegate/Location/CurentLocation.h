//
//  CurentLocation.h
//  Nurse
//
//  Created by Sandro on 15/12/12.
//  Copyright © 2015年 Sandro. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 .h 文件中导入以下两个框架
 */
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol CurrentLocationDelegate <NSObject>
@optional

- (void)getCurrentLocationLon:(NSString *)lon Lat:(NSString *)lan;
- (void)getCurrentArea:(NSString *)province City:(NSString *)city Area:(NSString *)area;
- (void)getCurrentLocationFail:(NSString *)error;

@end

@interface CurentLocation : NSObject<MKMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>{
    CLGeocoder  *_geoCoder;//创建地理编码对象
}
@property(nonatomic,strong) CLLocationManager *locaManager;

@property (nonatomic, assign) id<CurrentLocationDelegate> delegate;

//获取定位信息
-(void)getUSerLocation;
+ (CurentLocation *)sharedManager;

@end
