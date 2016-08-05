//
//  CtsiUserDefaults.m
//  mts-iphone
//
//  Created by Doulala on 15/8/6.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "CtsiUserDefaults.h"

@implementation CtsiUserDefaults
//NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary

-(instancetype) initWithTag:(NSString*) name{
    _defauls=[[NSUserDefaults alloc]initWithSuiteName:name];
    return self;
}

-(void) setString:(NSString*)value forKey:(NSString *)key{
    [_defauls setObject:value forKey:key];
    [_defauls synchronize];

}

-(void) setDictionary:(NSDictionary*)value forKey:(NSString *)key{
    [_defauls setObject:value forKey:key];
    [_defauls synchronize];
    
}
-(void) setArray:(NSArray*)value forKey:(NSString *)key{
    [_defauls setObject:value forKey:key];
    [_defauls synchronize];
    
}
-(void) setNumber:(NSNumber*)value forKey:(NSString *)key{
    [_defauls setObject:value forKey:key];
    [_defauls synchronize];
}
-(void) setInt:(int)value forKey:(NSString *)key{
    NSNumber*  number=[NSNumber numberWithInt:value];
    [self setNumber:number forKey:key];
}

-(void) setLongLong:(long long )value forKey:(NSString *)key{
    NSNumber*  number=[NSNumber numberWithLongLong:value];
    [self setNumber:number forKey:key];
}
-(void) setBoolean:(BOOL)value forKey:(NSString *)key{
    if(value){
        NSNumber* number=[NSNumber numberWithInt:1];
        [self setNumber:number forKey:key];
    }else{
        NSNumber* number=[NSNumber numberWithInt:0];
        [self setNumber:number forKey:key];
    }
    [_defauls synchronize];
}

-(NSString*)getStringByKey:(NSString*)key withDefault:(NSString*)defaultValue{
    
     NSString* value=  [_defauls valueForKey:key];
   
    if([DataUtil isEmptyString:value]){
        return defaultValue;
    }else{
        return value;
    }
}

-(int)getIntByKey:(NSString*)key withDefault:(int)defaultValue{
    
    NSNumber* value=  [_defauls valueForKey:key];
    
    if(value!=nil){
        return [value intValue];
    }else{
        return defaultValue;
    }
}
-(long long )getLonglongByKey:(NSString*)key withDefault:(long long )defaultValue{
    
    NSNumber* value=  [_defauls valueForKey:key];
    
    if(value!=nil){
        return [value longLongValue];
    }else{
        return defaultValue;
    }
}

-(BOOL)getBooleanByKey:(NSString*)key withDefault:(BOOL)defaultValue{
    
    NSNumber* value=  [_defauls valueForKey:key];
    
    if(value!=nil){
        return [value intValue]==1;
    }else{
        return defaultValue;
    }
}
-(NSDictionary*)getDictionaryByKey:(NSString*)key {
    
    NSDictionary* value=  [_defauls valueForKey:key];
    
    return value;
}
-(NSArray*)getArrayByKey:(NSString*)key{
    
    NSArray* value=  [_defauls valueForKey:key];
    return value;
}






@end
