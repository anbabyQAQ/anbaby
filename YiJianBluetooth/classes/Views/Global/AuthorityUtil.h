//
//  AuthorityUtil.h
//  mts-iphone
//
//  Created by 刘超 on 16/5/24.
//  Copyright © 2016年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>


//注意：这几个API接口是在ios7及以上系统可以访问


typedef enum {
    AuthorityStatusAuthorized = 1,
    AuthorityStatusNotDetermined,
    AuthorityStatusRestricted,
    AuthorityStatusDenied,
    AuthorityStatusUnknowed,
} AuthorityStatus;


@interface AuthorityUtil : NSObject

///获取拍照的权限
+(AuthorityStatus)getTakePhotoAuthority;

///获取系统相册的权限
+(AuthorityStatus)getPhotoLibraryAuthority;

///获取录像的权限
+(AuthorityStatus)getTakeVideoAuthority;

///获取麦克风录入声音的权限
+(AuthorityStatus)getVoiceInputAuthority;

///获取定位的权限
+(AuthorityStatus)getLocationServiceAuthority;



/*
 // 应用范例
 
 ///只提供系统资源权限访问的判断

 AuthorityStatus status = [AuthorityUtil getLocationServiceAuthority];
 switch (status) {
 case AuthorityStatusAuthorized:{
 NSLog(@"AuthorityStatusAuthorized");
 }
 break;
 case AuthorityStatusDenied:{
 NSLog(@"AuthorityStatusDenied");
 }
 
 default:
 break;
 }
 */

@end
