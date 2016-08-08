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

/** 顶部导航栏高度 */
#define NAVIGATION_HEIGHT 64.0f
//tabbar高度
#define TABBAR_HEIGHT 49.0f
//segment的高度
#define SEGMENT_HEIGHT 38.0f

#define text_size_huge 22.0f
#define text_size_large 18.0f
#define text_size_between_largeAndNormal 17
#define text_size_normal 16.0f
#define text_size_between_normalAndSmall 15
#define text_size_small 14.0f
#define text_size_between_smallAndSmaller 13
#define text_size_smaller 12.0f
#define text_size_tiny 10.0f

//iOS_fontsize * 72 / 96 = ps_size
//用于导航标题
#define text_size_36PX 14.0f
//用于标签，列表等大部分重要标题 如标签，标题名称
#define text_size_34PX 12.75f
//用于大多数文字和按钮
#define text_size_32PX 12.0f
//用于辅助性文字， 如次级辅助文字
#define text_size_30PX 11.25f
//主界面模块标题
#define text_size_28PX 10.5f
//主界面低栏标题
#define text_size_24PX 9.0f

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
