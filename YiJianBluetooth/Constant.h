//
//  Constant.h
//  mts-iphone
//
//  Created by 尹平 on 12-10-31.
//  Copyright (c) 2012年 中国电信. All rights reserved.
//

#ifndef mts_iphone_Constant_h
#define mts_iphone_Constant_h


// 错误码
typedef enum:NSUInteger{
    ErrorCodeForRequestTimeout = 1001, // 请求超时，服务器开小差
    ErrorCodeForOrderSendFailure = 1002, // 参数错误，订单发布失败
    ErrorCodeForFailureButCanContinue = 1003, // 失败但仍可继续
}OrderErrorCode;


#define defaultTimeout 10


/** 屏幕尺寸 */
#define SCR_BOUNDS [UIScreen mainScreen].bounds
/** 屏幕尺寸 */
#define SCR_SIZE [UIScreen mainScreen].bounds.size
/** 屏幕宽度 */
#define SCR_W [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define SCR_H [UIScreen mainScreen].bounds.size.height


//16进制GRB值 ，转UIColor
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif






#define EMPTY_STRING        @""
#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_DB [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"CTSI-MTS.db"]

#endif






#ifndef IS_IPHONE5
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_IPHONE4S (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)

#define IS_IPHONE6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)

#define IS_IOS8  [[[UIDevice currentDevice] systemVersion] floatValue]>=8

#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion <= 7.0)
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height



//16进制GRB值 ，转UIColor
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//划线颜色
#define Color_Border_Custom [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1]


#endif
