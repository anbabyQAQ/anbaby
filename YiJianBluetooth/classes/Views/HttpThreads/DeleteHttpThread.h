//
//  DeleteHttpThread.h
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/9/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDelegate.h"
#import "AFNetworking.h"

@interface DeleteHttpThread : NSObject<HttpDelegate>{

    NSString * _url;
    NSInteger _timeout;
    NSDictionary * _params;
    NSURLSessionDataTask * _task;
}

@property NSString * url;
@property NSInteger timeout;
@property NSDictionary* params;
@property NSURLSessionDataTask * task;

-(void) require;

-(void)cancel;

-(void)setUrl:(NSString *)url andTimeout:(NSInteger) timeout;



@end
