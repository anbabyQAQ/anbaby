
//
//  GetRegisterThred.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/29.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "GetRegisterThred.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"

@implementation GetRegisterThred
-(instancetype) initWithUserName:(NSString *)mdn withPassword:(NSString *)password withType:(NSString *)type{
    
    
    [self setUrl:@"http://dev.ezjian.com/login/register" andTimeout:defaultTimeout];
    
        NSMutableDictionary* data=[NSMutableDictionary dictionary];
    
        NSMutableDictionary* params=[NSMutableDictionary dictionary];
        [params setValue:mdn forKey:@"username"];
        [params setValue:password forKey:@"password"];
        [params setValue:type forKey:@"type"];
    
        [data setValue:[params JSONRepresentation] forKey:@"data"];
    
        self.params=data;
    return self;

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
        NSDictionary *dic = [result JSONValue];
        
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
