//
//  HttpDelegate.h
//  mts-iphone
//
//  Created by tyl on 16/8/4.
//  Copyright (c) 2016年 中国电信. All rights reserved.
//


@protocol HttpDelegate <NSObject>
@required
-(void)onPrev;

-(void)onUnavaliableNetwork;

-(void)onSuccess:(NSString *)result;

-(void)onTimeout;

-(void)exception:(NSInteger) code message:(NSString *) message;

-(void)onCancelled;



@end
