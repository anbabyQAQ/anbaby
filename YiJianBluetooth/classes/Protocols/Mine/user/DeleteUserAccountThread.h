//
//  DeleteUserAccountThread.h
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/9/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeleteHttpThread.h"
@interface DeleteUserAccountThread : DeleteHttpThread

@property (nonatomic, copy) void (^prev)();
@property (nonatomic, copy) void (^unavaliableNetwork)();
@property (nonatomic, copy) void (^timout)();
@property (nonatomic, copy) void (^success)(NSDictionary* response);
@property (nonatomic, copy) void (^exception)(NSString* message);

-(instancetype)initWithAid:(NSString *)aid withuid:(NSString *)uid withToken:(NSString *)token;

-(void)requireonPrev:(void (^)())prev success:(void (^)(NSDictionary* response))success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception;

@end
