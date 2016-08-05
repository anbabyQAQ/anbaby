//
//  CTSIGlobalUserDefault.h
//  mts-iphone
//
//  Created by ctsi on 13-7-10.
//  Copyright (c) 2013年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTSIGlobalUserDefault : NSUserDefaults

- (void)setObject:(id)value forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;
@end
