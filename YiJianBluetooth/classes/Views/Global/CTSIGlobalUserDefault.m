//
//  CTSIGlobalUserDefault.m
//  mts-iphone
//
//  Created by ctsi on 13-7-10.
//  Copyright (c) 2013年 中国电信. All rights reserved.
//

#import "CTSIGlobalUserDefault.h"

@implementation CTSIGlobalUserDefault

- (void)setObject:(id)value forKey:(NSString *)defaultName{
    [super setObject:value forKey:defaultName];
    [super synchronize];
}
- (void)removeObjectForKey:(NSString *)defaultName{
    [super removeObjectForKey:defaultName];
    [super synchronize];
}

@end
