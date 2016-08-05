//
//  ApiBase.m
//  mts-iphone
//
//  Created by tyl on 16/8/3.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//
#import <objc/runtime.h>
#import "ApiBase.h"

@interface ApiBase()

+ (NSArray *)arrayWithJsonArray:(NSArray *)jsonArray class:(Class)class;
- (Class)classForProperty:(NSString *)property;

@end

@implementation ApiBase

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *properyName in [ApiBase propertiesForClass:[self class]]) {
        [aCoder encodeObject:[self valueForKey:properyName] forKey:properyName];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        for (NSString *propertyName in [ApiBase propertiesForClass:[self class]]) {
            if ([aDecoder containsValueForKey:propertyName]) {
                [self setValue:[aDecoder decodeObjectForKey:propertyName] forKeyPath:propertyName];
            }
        }
    }
    return self;
}

- (void)setValueWithObject:(id)obj
{
    NSArray *properties = [ApiBase propertiesForClass:[obj class]];
    for (NSString *property in properties) {
        id value = [obj valueForKey:property];
        SEL sel = NSSelectorFromString(property);
        if (value && [self respondsToSelector:sel]) {
            [self setValue:value forKey:property];
        }
    }
}

+ (NSArray *)arrayWithJsonArray:(NSArray *)jsonArray class:(Class)class
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id jsonObject in jsonArray) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            [array addObject:[[class alloc] initWithJsonDictionary:jsonObject]];
        } else {
            [array addObject:jsonObject];
        }
    }
    return array;
}

+ (id)objectWithJsonData:(NSData *)jsonData
{
    if (jsonData) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                return [[self alloc] initWithJsonDictionary:jsonObject];
            } else if ([jsonObject isKindOfClass:[NSArray class]]) {
                return [self arrayWithJsonArray:jsonObject class:self];
            } else {
                return jsonObject;
            }
        } else {
            NSLog(@"json data error: %@", error.localizedDescription);
            return nil;
        }
    } else {
        return nil;
    }
}

+ (id)objectWithJsonOjbect:(id)jsonOjbect
{
    if (jsonOjbect) {
        NSError *error;
        id jsonObject = jsonOjbect;
        if (!error) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                return [[self alloc] initWithJsonDictionary:jsonObject];
            } else if ([jsonObject isKindOfClass:[NSArray class]]) {
                return [self arrayWithJsonArray:jsonObject class:self];
            } else {
                return jsonObject;
            }
        } else {
            NSLog(@"json data error: %@", error.localizedDescription);
            return nil;
        }
    } else {
        return nil;
    }
}

- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self && jsonDictionary&& [jsonDictionary isKindOfClass:[NSDictionary class]]) {
        NSDictionary *mappingDic = nil;
        if ([self respondsToSelector:@selector(propertyMapping)]) {
            mappingDic = [self propertyMapping];
        }
        
        for (NSString *key in jsonDictionary.allKeys) {
            NSString *selectorKey = key;
            if (mappingDic && [mappingDic objectForKey:key]) {
                selectorKey = [mappingDic objectForKey:key];
            }
            SEL selectorName = NSSelectorFromString(selectorKey);
            if ([self respondsToSelector:selectorName]) {
                id value = [jsonDictionary objectForKey:key];
                if ([value isKindOfClass:[NSArray class]]) {
                    NSArray *array = [[self class] arrayWithJsonArray:value class:[self classForArray:selectorKey]];
                    [self setValue:array forKey:selectorKey];
                } else if ([value isKindOfClass:[NSDictionary class]]) {
                    id object = [[[self classForProperty:selectorKey] alloc] initWithJsonDictionary:value];
                    [self setValue:object forKey:selectorKey];
                } else {
                    if (value == [NSNull null]) {
                        value = nil;
                    }
                    [self setValue:value forKey:selectorKey];
                }
            }
        }
    }
    return self;
}

- (Class)classForProperty:(NSString *)property
{
    NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(class_getProperty(self.class, property.UTF8String))];
    NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
    if ([splitPropertyAttributes count] >= 2)
    {
        return NSClassFromString([splitPropertyAttributes objectAtIndex:1]);
    } else {
        return nil;
    }
}

+ (NSArray *)propertiesForClass:(Class) aClass
{
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    for (unsigned int i = 0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNamesArr addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNamesArr;
}

@end