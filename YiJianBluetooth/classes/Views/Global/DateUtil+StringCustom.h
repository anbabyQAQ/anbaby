//
//  DateUtil+StringCustom.h
//  mts-iphone
//
//  Created by lizhe on 15/10/28.
//  Copyright © 2015年 中国电信. All rights reserved.
//

#import "DateUtil.h"

@interface DateUtil (StringCustom)

+ (NSString *)getTimeStringCustom:(NSDate*)date;

+ (NSString *)getMyTaskProcessWithEndDate:(NSDate*)endDate;

@end
