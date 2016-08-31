//
//  PostUserAccountThred.h
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/8/31.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostJsonHttpThread.h"
@interface PostUserAccountThred : PostJsonHttpThread

@property (nonatomic, copy) void (^prev)();
@property (nonatomic, copy) void (^unavaliableNetwork)();
@property (nonatomic, copy) void (^timout)();
@property (nonatomic, copy) void (^success)(NSDictionary* response);
@property (nonatomic, copy) void (^exception)(NSString* message);

-(instancetype)initWithAid:(NSString *)aid withToken:(NSString *)token widthData:(NSMutableDictionary *)dataDic;

-(void)requireonPrev:(void (^)())prev success:(void (^)(NSDictionary* response))success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception;

@end
