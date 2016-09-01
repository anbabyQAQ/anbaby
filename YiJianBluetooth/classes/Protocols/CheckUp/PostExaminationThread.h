//
//  PostExaminationThread.h
//  YiJianBluetooth
//
//  Created by tyl on 16/9/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "PostJsonHttpThread.h"

@interface PostExaminationThread : PostJsonHttpThread

#define kPostExaminationThreadUrl @"http://dev.ezjian.com/project/notelist"


@property (nonatomic, copy) void (^prev)();
@property (nonatomic, copy) void (^unavaliableNetwork)();
@property (nonatomic, copy) void (^timout)();
@property (nonatomic, copy) void (^success)();
@property (nonatomic, copy) void (^exception)(NSString* message);

-(instancetype) initWithToken:(NSString *)token type:(NSString *)type  withdata:(NSDictionary *)data;

-(void)requireonPrev:(void (^)())prev success:(void (^)())success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception;

@end
