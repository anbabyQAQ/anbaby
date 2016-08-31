//
//  GetRegisterThred.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/29.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "PostJsonHttpThread.h"

#define kRegisterString @"http://dev.ezjian.com/login/register"


@interface GetRegisterThred : PostJsonHttpThread



@property (nonatomic, copy) void (^prev)();
@property (nonatomic, copy) void (^unavaliableNetwork)();
@property (nonatomic, copy) void (^timout)();
@property (nonatomic, copy) void (^success)(NSDictionary* response);
@property (nonatomic, copy) void (^exception)(NSString* message);

-(instancetype) initWithUserName:(NSString *)mdn withPassword:(NSString *)password withType:(NSString *)type;

-(void)requireonPrev:(void (^)())prev success:(void (^)(NSDictionary* response))success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception;
@end
