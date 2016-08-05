//
//  PostLoginThread.m
//  mts-iphone
//
//  Created by 刘超 on 15/11/18.
//  Copyright © 2015年 中国电信. All rights reserved.
//

#import "PostLoginThread.h"

@implementation PostLoginThread
-(instancetype) initWithMdn:(NSString *)mdn withPassword:(NSString *)password{
    if (self = [super init]) {
        [self setUrl:kPostLoginUrl andTimeout:defaultTimeout];
        NSMutableDictionary *keyValuePair = [[NSMutableDictionary alloc] init];
        if (mdn) {
            [keyValuePair setValue: mdn forKey:@"mdn"];
        }
        if (password) {
            [keyValuePair setValue:password forKey:@"password"];
        }
        [keyValuePair setValue:@"1" forKey:@"devType"];
        [keyValuePair setValue:@"0" forKey:@"configStamp"];

        self.params=keyValuePair;
        NSLog(@"%@",self.params.JSONRepresentation);
        return self;
    }else{
        return nil;
    }
}

-(void)requireonPrev:(void (^)())prev success:(void (^)(NSDictionary* response))success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception{
    self.prev=prev;
    self.unavaliableNetwork=unavaliableNetwork;
    self.timout=timeout;
    self.success=success;
    self.exception=exception;
    [self require];
}
-(void)onPrev{
    [super onPrev];
    if(self.prev){
        self.prev();
    }
}

-(void)onUnavaliableNetwork{
    [super onUnavaliableNetwork];
    if(self.unavaliableNetwork){
        self.unavaliableNetwork();
    }
}

-(void)onSuccess:(NSString *)result{
    [super onSuccess:result];
    if(self.success)
    {
        NSDictionary * dic=[result JSONValue];
        
        NSNumber* num_code=[DataUtil numberForKey:@"code" inDictionary:dic];
        NSInteger code=[num_code integerValue];
        NSString* message=[dic valueForKey:@"message"];
        NSDictionary * responseDic=[NSDictionary dictionary];
        responseDic = [DataUtil dictionaryForKey:@"response" inDictionary:dic];
//        Configuration * config=[[Configuration alloc]initWithDictionary:responseDic];
////        long long serverTime=[dic valueForKey:@"serverTime"];
        if(code==0){
            [self exception:0 message:message];
        }else{
        
            self.success(responseDic);
        }
        
    }
}

-(void)onTimeout{
    [super onTimeout];
    if(self.timout){
        self.timout();
    }
    
    
}

-(void)exception:(NSInteger) code message:(NSString *) message{
    [super exception:code message:message];
    if(self.exception)
        self.exception(message);
    
}

-(void)onCancelled{
    [super onCancelled];
}

@end
