//
//  DateUtil.m
//  mts-iphone
//
//  Created by 李曜 on 15/4/24.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSString* )DateFormatToString:(NSDate*) date WithFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];

}

+(NSDate*)SecondsToDate:(long long) seconds{
    return  [[NSDate alloc]initWithTimeIntervalSince1970:seconds];
}

+(NSDate*)MilliSecondsToDate:(NSNumber *) millisecond{

    return [DateUtil SecondsToDate:([millisecond longLongValue])/1000];

}
+(NSNumber *)dateToNumber:(NSDate *)date{
    return [NSNumber numberWithLongLong:[date timeIntervalSince1970]];    
}
+(NSNumber *)dateToMillionNumber:(NSDate *)date{
    return [NSNumber numberWithLongLong:[date timeIntervalSince1970] * 1000];
}


+(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  timeString=[dateFormatter stringFromDate:date];
    return timeString;

}
+(NSString *)dateToStringnew:(NSDate *)date{
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *timeString=[dateFormatter stringFromDate:date];
    return timeString;
    
}
+(NSString*)dateToGMTString:(NSDate*)date;
{  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@ "EEE, dd MMM yyyy HH:mm:ss z"];
    NSString* result= [dateFormatter stringFromDate:date];
    NSLog(@"print date is %@",result);
    return result;
}


+(NSDate*)dateWithYear:(NSInteger)year andWithMonth:(NSInteger)month andWithDay:(NSInteger)day andWithHour:(NSInteger)hour andWithMinute:(NSInteger)minute andWithSecond:(NSInteger)seconds{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:month];
    [comp setDay:day];
    [comp setYear:year];
    [comp setHour:hour];
    [comp setMinute:minute];
    [comp setSecond:seconds];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    return [myCal dateFromComponents:comp];
}
+(NSDateComponents *) getComponentsByDate:(NSDate*)date{

NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit|NSSecondCalendarUnit;
NSDateComponents * comps = [calendar components:unitFlags fromDate:date];
    return comps;
}
@end
