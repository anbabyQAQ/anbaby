//
//  DeleteHttpThread.m
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/9/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "DeleteHttpThread.h"

@implementation DeleteHttpThread


-(void)setUrl:(NSString *)url andTimeout:(NSInteger) timeout{
    
    self.url=url;
    self.timeout=timeout;
}
-(void)require
{
    
    [self onPrev];
    //    self.task=nil;
    //检测网络
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
                [self onUnavaliableNetwork];
                break;
            default:
                [self http];
                break;
        }
        
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
-(void)http{
    
    AFHTTPSessionManager  *sessionManager = [AFHTTPSessionManager manager];
    
    //https 证书认证 创建securityPolicy
    //    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //    [sessionManager.requestSerializer setValue:[self getHelpToken] forHTTPHeaderField:@"Authorization"];
    
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    if (self.timeout>0) {
        sessionManager.requestSerializer.timeoutInterval = self.timeout;
    }
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.task =  [sessionManager DELETE:self.url parameters:self.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        [self onSuccess:result];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse* response=task.response;
        NSString* str_error=[NSString stringWithFormat:@"%@",error];
        //        [LogUtil write:@"exception" value:str_error];
        
        if(error.code==-ErrorCodeForRequestTimeout)
        {
            [self onTimeout];
        }
        else{
            [self exception:response.statusCode message:str_error];
        }

    }];
    
    
}



-(void)cancel{
    if(self.task){
        [self.task cancel];
        [self onCancelled];
    }
}


-(void)onPrev{
    //    [LogUtil write:@"url" value:self.url];
    //    [LogUtil write:@"params" value:[self.params JSONRepresentation]];
    
}

-(void)onUnavaliableNetwork{
    //    [LogUtil write:@"excption" value:@"unavaliableNetwork"];
}

-(void)onSuccess:(NSString *)result{
    //  [LogUtil write:@"result" value:result];
}

-(void)onTimeout{
    // [LogUtil write:@"excption" value:@"timeout"];
}

-(void)exception:(NSInteger) code message:(NSString *) message{
    //[LogUtil write:@"excption" value:message];
    
}

-(void)onCancelled{
    
    
}


@end
