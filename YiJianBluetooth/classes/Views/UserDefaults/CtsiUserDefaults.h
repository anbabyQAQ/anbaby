//
//  CtsiUserDefaults.h
//  mts-iphone
//
//  Created by Doulala on 15/8/6.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CtsiUserDefaults : NSObject
{
    NSUserDefaults* _defauls;

}
-(instancetype) initWithTag:(NSString*) name;

-(void) setString:(NSString*)value forKey:(NSString *)key;
-(void) setInt:(int)value forKey:(NSString *)key;
-(void) setLongLong:(long long )value forKey:(NSString *)key;
-(void) setNumber:(NSNumber*)value forKey:(NSString *)key;
-(void) setBoolean:(BOOL)value forKey:(NSString *)key;
-(void) setDictionary:(NSDictionary*)value forKey:(NSString *)key;
-(void) setArray:(NSArray*)value forKey:(NSString *)key;


-(NSString*)getStringByKey:(NSString*)key withDefault:(NSString*)defaultValue;
-(int)getIntByKey:(NSString*)key withDefault:(int)defaultValue;
-(long long )getLonglongByKey:(NSString*)key withDefault:(long long )defaultValue;
-(BOOL)getBooleanByKey:(NSString*)key withDefault:(BOOL)defaultValue;
-(NSDictionary*)getDictionaryByKey:(NSString*)key;
-(NSArray*)getArrayByKey:(NSString*)key;


@end
