//
//  PostLoginThread.h
//  mts-iphone
//
//  Created by 刘超 on 15/11/18.
//  Copyright © 2015年 中国电信. All rights reserved.
//

#import "PostJsonHttpThread.h"

@interface PostLoginThread : PostJsonHttpThread

#define kRegisterString @"mts-ci/v210/isregister"

#define kPostLoginUrl [[NSString stringWithFormat:@"%@",kRegisterString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@property (nonatomic, copy) void (^prev)();
@property (nonatomic, copy) void (^unavaliableNetwork)();
@property (nonatomic, copy) void (^timout)();
@property (nonatomic, copy) void (^success)(NSDictionary* response ,NSString *token);
@property (nonatomic, copy) void (^exception)(NSString* message);

-(instancetype) initWithMdn:(NSString *)mdn withPassword:(NSString *)password;

-(void)requireonPrev:(void (^)())prev success:(void (^)(NSDictionary* response,NSString *token))success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception;


@end
