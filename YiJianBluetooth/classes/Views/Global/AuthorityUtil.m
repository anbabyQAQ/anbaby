//
//  AuthorityUtil.m
//  mts-iphone
//
//  Created by 刘超 on 16/5/24.
//  Copyright © 2016年 中国电信. All rights reserved.
//

#import "AuthorityUtil.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAudioSession.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

#define kDeviceVersion [UIDevice currentDevice].systemVersion.floatValue
#define kTakePhotoHelpString          @"请在“设置-隐私-相机”选项中允许外勤助手访问您的相机"
#define kPhotoLibraryHelpString       @"请在“设置-隐私-照片”选项中允许外勤助手访问您的照片库"
#define kTakeVideoHelpString          @"请在“设置-隐私-相机”选项中允许外勤助手访问您的相机"
#define kVoiceInputHelpString         @"请在“设置-隐私-麦克风”选项中允许外勤助手访问您的麦克风"
#define kLocationServiceHelpString    @"请在“设置-隐私-定位服务”选项中开启系统的定位服务选项"
#define kLocationEnableHelpString     @"请在“设置-隐私-定位服务-外勤助手-始终”选项中允许外勤助手定位"

@implementation AuthorityUtil

//获取拍照的权限
+(AuthorityStatus)getTakePhotoAuthority{
    if (kDeviceVersion < 7.0f) {
        return AuthorityStatusUnknowed;
    }
    __block AuthorityStatus _status=AuthorityStatusDenied;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            NSLog(@"AVAuthorizationStatusNotDetermined");
            _status = AuthorityStatusNotDetermined;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    _status = AuthorityStatusAuthorized;
                } else {
                    _status = AuthorityStatusDenied;
                }
            }];

        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            NSLog(@"AVAuthorizationStatusRestricted");
            _status = AuthorityStatusRestricted;

        }
            break;
        case AVAuthorizationStatusDenied:
        {
            NSLog(@"AVAuthorizationStatusDenied");
            _status = AuthorityStatusDenied;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"无法拍照" message:kTakePhotoHelpString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            });

        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            NSLog(@"AVAuthorizationStatusAuthorized");
            _status = AuthorityStatusAuthorized;

        }
            break;

        default:{
            _status = AuthorityStatusNotDetermined;
        }
            break;
    }
    return _status;
}

//获取系统相册的权限
+(AuthorityStatus)getPhotoLibraryAuthority{
    if (kDeviceVersion < 6.0f) {
        return AuthorityStatusUnknowed;
    }
    AuthorityStatus _status=AuthorityStatusDenied;
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    switch (author) {
        case ALAuthorizationStatusNotDetermined:
        {
            NSLog(@"ALAuthorizationStatusNotDetermined");
            _status = AuthorityStatusNotDetermined;
        }
            break;
        case ALAuthorizationStatusRestricted:
        {
            NSLog(@"ALAuthorizationStatusRestricted");
            _status = AuthorityStatusRestricted;
        }
            break;
        case ALAuthorizationStatusDenied:
        {
            NSLog(@"ALAuthorizationStatusDenied");
            _status = AuthorityStatusDenied;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"无法打开照片" message:kPhotoLibraryHelpString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            });

        }
            break;
        case ALAuthorizationStatusAuthorized:
        {
            NSLog(@"ALAuthorizationStatusAuthorized");
            _status = AuthorityStatusAuthorized;
        }
            break;
            
        default:{
            _status = AuthorityStatusNotDetermined;
        }
            break;
    }
    return _status;
}
//获取录像的权限
+(AuthorityStatus)getTakeVideoAuthority{
    if (kDeviceVersion < 7.0f) {
        return AuthorityStatusUnknowed;
    }
    AuthorityStatus _status=AuthorityStatusDenied;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            NSLog(@"AVAuthorizationStatusNotDetermined");
            _status = AuthorityStatusNotDetermined;
            
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            NSLog(@"AVAuthorizationStatusRestricted");
            _status = AuthorityStatusRestricted;
            
        }
            break;
        case AVAuthorizationStatusDenied:
        {
            NSLog(@"AVAuthorizationStatusDenied");
            _status = AuthorityStatusDenied;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"无法录像" message:kTakeVideoHelpString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            });            
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            NSLog(@"AVAuthorizationStatusAuthorized");
            _status = AuthorityStatusAuthorized;
        }
            break;
            
        default:{
            _status = AuthorityStatusNotDetermined;
        }
            break;
    }
    return _status;
}

//获取麦克风录入声音的权限
+(AuthorityStatus)getVoiceInputAuthority{
    if (kDeviceVersion < 7.0f) {
        return AuthorityStatusUnknowed;
    }
    __block AuthorityStatus _status=AuthorityStatusDenied;
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [avSession requestRecordPermission:^(BOOL available) {
            
            if (available) {
                //completionHandler
                _status = AuthorityStatusAuthorized;
            }
            else
            {
                _status = AuthorityStatusDenied;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音" message:kVoiceInputHelpString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
        }];
        
    }

    return _status;
}

//获取定位的权限
+(AuthorityStatus)getLocationServiceAuthority{
    if (kDeviceVersion < 6.0f) {
        return AuthorityStatusUnknowed;
    }
    AuthorityStatus _status=AuthorityStatusDenied;
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"说明系统的定位服务总开关是开着的");
        CLAuthorizationStatus authorityStatus = [CLLocationManager authorizationStatus];
        switch (authorityStatus) {
            case kCLAuthorizationStatusNotDetermined:
            {
                NSLog(@"kCLAuthorizationStatusNotDetermined");
                _status= AuthorityStatusNotDetermined;
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                NSLog(@"kCLAuthorizationStatusRestricted");
                _status= AuthorityStatusRestricted;
            }
                break;
            case kCLAuthorizationStatusDenied:
            {
                NSLog(@"kCLAuthorizationStatusDenied");
                _status = AuthorityStatusDenied;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法定位" message:kLocationEnableHelpString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            {
                NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
                _status = AuthorityStatusAuthorized;
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {
                NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
                _status = AuthorityStatusAuthorized;
                
            }
                break;
                
            default:
            {
                _status = AuthorityStatusNotDetermined;
                
            }
                break;
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"定位服务关闭" message:kLocationServiceHelpString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        });
    }
    
    return _status;
}

@end
