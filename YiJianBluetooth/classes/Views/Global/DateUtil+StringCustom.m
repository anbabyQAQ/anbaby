//
//  DateUtil+StringCustom.m
//  mts-iphone
//
//  Created by lizhe on 15/10/28.
//  Copyright © 2015年 中国电信. All rights reserved.
//

#import "DateUtil+StringCustom.h"

@implementation DateUtil (StringCustom)


/***
 * 今天： 返回今天 上下午+时间
 * 昨天： 返回昨天
 * 以前： 返回日期
 **/
+ (NSString *)getTimeStringCustom:(NSDate*)date {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate * needFormatDate = date;
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    
    NSString * dateString = [[needFormatDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]) {
        [dateFormatter setDateFormat:@"HH"];
        NSString * hourString = [dateFormatter stringFromDate:needFormatDate];
        NSInteger hourInt = [hourString intValue];
        [dateFormatter setDateFormat:@"h:mm"];
        if (0 <= hourInt && hourInt <12) {
            return [NSString stringWithFormat: @"上午 %@", [dateFormatter stringFromDate:needFormatDate]];
        } else {
            return [NSString stringWithFormat: @"下午 %@", [dateFormatter stringFromDate:needFormatDate]];
        }
        
    } else if ([dateString isEqualToString:yesterdayString]) {
        return @"昨天";
    }
    else {
        return dateString;
    }
}


+ (NSString *)getMyTaskProcessWithEndDate:(NSDate*)endDate {
    
    NSDate *nowDate = [NSDate date];
    long long nowNum = [DateUtil dateToNumber:nowDate].longLongValue;
    long long endNum = [DateUtil dateToNumber:endDate].longLongValue;
    long long plus = endNum - nowNum;
    NSString *processString = @" 未办 ";
    if (plus <= 0) {
        processString = @" 过期 ";
    } else if (plus < 60 * 60 *24) {
        processString = @" 即将过期 ";
    }
    return processString;
}
@end
