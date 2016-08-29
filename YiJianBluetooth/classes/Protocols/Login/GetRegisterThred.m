
//
//  GetRegisterThred.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/29.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "GetRegisterThred.h"
#import "SBJsonParser.h"

@implementation GetRegisterThred
-(instancetype) initWithUserName:(NSString *)mdn withPassword:(NSString *)password withType:(NSString *)type{
    
    
        [self setUrl:@"http://192.9.100.76:60001/mts-ci/v199/template/feed/13311097869" andTimeout:defaultTimeout];
       
        
        NSMutableDictionary* params=[NSMutableDictionary dictionary];
        [params setValue:@"0" forKey:@"minTime"];
        [params setValue:@"0" forKey:@"maxTime"];
        [params setValue:@"20" forKey:@"limit"];
        [params setValue:@"2" forKey:@"type"];
        
    

        
        self.params=params;
    
    
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
        NSDictionary *dic = [[[SBJsonParser alloc]init] objectWithString:result];
        
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
