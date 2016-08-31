//
//  CurentLocation.m
//  Nurse
//
//  Created by Sandro on 15/12/12.
//  Copyright © 2015年 Sandro. All rights reserved.
//

/*.m文件中实现代码如下*/
#import "CurentLocation.h"


@implementation CurentLocation


- (instancetype)init{
    self = [super init];
    if (self) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return self;
}

//定位回调代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    
    CLLocation *currLocation=[locations lastObject];
    
    [self getAddressByLatitude:currLocation];
    
    NSString *mylat = [NSString stringWithFormat:@"%f",currLocation.coordinate.latitude];
    NSString *mylon = [NSString stringWithFormat:@"%f",currLocation.coordinate.longitude];
    
    NSUserDefaults *ud1 = [NSUserDefaults standardUserDefaults];
    [ud1 setObject:mylat forKey:@"mylat"];
    [ud1 setObject:mylon forKey:@"mylon"];
    
    
   
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(getFinishLocation) object:nil];
    [self performSelector:@selector(getFinishLocation) withObject:nil afterDelay:1.0];
    
}

- (void)getFinishLocation {
    NSUserDefaults *ud1 = [NSUserDefaults standardUserDefaults];
    
    NSString *mylat = [ud1 objectForKey:@"mylat"];
    NSString *mylon = [ud1 objectForKey:@"mylon"];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentLocationLon1:Lat:)]) {
//        [self.delegate getCurrentLocationLon1:mylon Lat:mylat];
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentLocationLon:Lat:)]) {
        [self.delegate getCurrentLocationLon:mylon Lat:mylat];
    }
}

#pragma mark 根据坐标取得地名
- (void)getAddressByLatitude:(CLLocation *)location{
    [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //获取地标
        CLPlacemark *placemark = [placemarks firstObject];
        if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentArea:City:Area:)]) {
            [self.delegate getCurrentArea:placemark.administrativeArea City:placemark.locality Area:placemark.subLocality];
        }
    }];
}

- (void)getFinishLocation1 {
    NSUserDefaults *ud1 = [NSUserDefaults standardUserDefaults];
    
    NSString *mylat = [ud1 objectForKey:@"mylat"];
    NSString *mylon = [ud1 objectForKey:@"mylon"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentLocationLon:Lat:)]) {
        [self.delegate getCurrentLocationLon:mylon Lat:mylat];
    }
}

#pragma mark - 检测应用是否开启定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            [self openGPSTips];
            break;
//        case kCLErrorLocationUnknown:
//            break;
        default:
            if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentLocationFail:)]) {
                [self.delegate getCurrentLocationFail:nil];
            }
            break;
    }
}

- (void)openGPSTips {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未开启定位，请到“设置->隐私->定位服务->金牌护士”中开启定位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

//获取定位信息
- (void)getUSerLocation{
    //初始化定位管理类
    _locaManager = [[CLLocationManager alloc] init];
    //delegate
    _locaManager.delegate = self;
    //The desired location accuracy.//精确度
    _locaManager.desiredAccuracy = kCLLocationAccuracyBest;
    //Specifies the minimum update distance in meters.
    //距离
    _locaManager.distanceFilter = 10;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [_locaManager requestWhenInUseAuthorization];
        [_locaManager requestAlwaysAuthorization];
        
    }
    //开始定位
    [_locaManager startUpdatingLocation];
}

+ (CurentLocation *)sharedManager{
    static CurentLocation *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end