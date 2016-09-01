//
//  PostUserAccountThred.m
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/8/31.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "PostUserAccountThred.h"
#import "SBJsonWriter.h"
@implementation PostUserAccountThred

-(instancetype)initWithAid:(NSString *)aid withToken:(NSString *)token widthData:(NSMutableDictionary *)dataDic{

    [self setUrl:@"http://dev.ezjian.com/user/account" andTimeout:defaultTimeout];
    
    NSMutableDictionary* data=[NSMutableDictionary dictionary];
    
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    [params setValue:aid forKey:@"aid"];
    [params setValue:token forKey:@"token"];
    [params setValue:dataDic forKey:@"data"];
    
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
        //        Configuration * config=[[Configuration alloc]initWithDictionary:responseDic];
        ////        long long serverTime=[dic valueForKey:@"serverTime"];
        if(code==200){
            self.success(responseDic);
            
        }else if(code == 201){
            [self exception:0 message:@"用户已存在"];
            
        }else{
            [self exception:0 message:message];
            
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
