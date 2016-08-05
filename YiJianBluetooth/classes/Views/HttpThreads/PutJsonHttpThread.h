//
//  PutJsonHttpThread.h
//  mts-iphone
//
//  Created by tyl on 16/8/4.
//  Copyright (c) 2016年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDelegate.h"
#import "AFNetworking.h"
@interface PutJsonHttpThread : NSObject<HttpDelegate>{
    
    NSString * _url;
    NSInteger _timeout;
    NSDictionary * _params;
    NSURLSessionDataTask * _task;
    //    enum HttpStatus _status;
}

@property NSString * url;
@property NSInteger timeout;
@property NSDictionary* params;
@property NSURLSessionDataTask * task;

-(void) require;

-(void)cancel;

-(void)setUrl:(NSString *)url andTimeout:(NSInteger) timeout;



@end
