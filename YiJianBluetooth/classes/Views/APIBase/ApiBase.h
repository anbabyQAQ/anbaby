//
//  ApiBase.h
//  mts-iphone
//
//  Created by tyl on 16/8/3.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApiBase <NSObject>

@optional

- (Class)classForArray:(NSString *)arrayKey;

- (NSDictionary *)propertyMapping;

@end

@interface ApiBase : NSObject <ApiBase,NSCoding>

+ (id)objectWithJsonData:(NSData *)jsonData;

+ (id)objectWithJsonOjbect:(id)jsonOjbect;

- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary;

+ (NSArray *)propertiesForClass:(Class) aClass;

- (void)setValueWithObject:(id)obj;


- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

@end

