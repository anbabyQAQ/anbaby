//
//  LogUtil.h
//  mts-iphone
//
//  Created by 李曜 on 15/6/2.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogUtil : UIViewController

+(void)write:(NSString*)str;

+(void)write:(NSString*) key value:(NSString*)value;

@end
