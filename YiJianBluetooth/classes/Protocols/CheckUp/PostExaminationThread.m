//
//  PostExaminationThread.m
//  YiJianBluetooth
//
//  Created by tyl on 16/9/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "PostExaminationThread.h"

@implementation PostExaminationThread
-(instancetype) initWithToken:(NSString *)token type:(NSString *)type  withdata:(NSDictionary *)data{

    [self setUrl:kPostExaminationThreadUrl andTimeout:defaultTimeout];
    
    NSMutableDictionary* param_data=[NSMutableDictionary dictionary];
    
    
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    [params setValue:type forKey:@"type"];
    [params setValue:token forKey:@"token"];
    [params setValue:data forKey:@"data"];
    
    [param_data setValue:[params JSONRepresentation] forKey:@"data"];
    
    self.params=data;
    return self;
}

-(void)requireonPrev:(void (^)())prev success:(void (^)(NSDictionary* response,NSString *token))success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception{
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
        
        if(code==200){
            self.success();
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
