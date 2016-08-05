//
//  DateUtil.h
//  mts-iphone
//
//  Created by 李曜 on 15/4/24.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+(NSString* )DateFormatToString:(NSDate*) date WithFormat:(NSString*)format;

+(NSDate*)SecondsToDate:(long long) seconds;

+(NSDate*)MilliSecondsToDate:(NSNumber *) millisecond;


+(NSNumber *)dateToNumber:(NSDate *)date;
+(NSNumber *)dateToMillionNumber:(NSDate *)date;

+(NSString *)dateToString:(NSDate *)date;
+(NSString *)dateToStringnew:(NSDate *)date;

+(NSString*)dateToGMTString:(NSDate*)date;

+(NSDate*)dateWithYear:(NSInteger)year andWithMonth:(NSInteger)month andWithDay:(NSInteger)day andWithHour:(NSInteger)hour andWithMinute:(NSInteger)minute andWithSecond:(NSInteger)seconds;

+(NSDateComponents *) getComponentsByDate:(NSDate*)date;
@end
