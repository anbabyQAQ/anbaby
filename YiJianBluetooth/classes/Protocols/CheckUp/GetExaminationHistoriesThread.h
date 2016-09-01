//
//  GetExaminationHistoriesThread.h
//  YiJianBluetooth
//
//  Created by tyl on 16/9/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "GetHttpThread.h"

#define kGetExaminationHistoriesThreadUrl @"http://dev.ezjian.com/project/notelist"


@interface GetExaminationHistoriesThread : GetHttpThread



@property (nonatomic, copy) void (^prev)();
@property (nonatomic, copy) void (^unavaliableNetwork)();
@property (nonatomic, copy) void (^timout)();
@property (nonatomic, copy) void (^success)(NSDictionary* response);
@property (nonatomic, copy) void (^exception)(NSString* message);

-(instancetype) initWithaid:(NSString *)aid withuid:(NSString *)uid withType:(NSString *)type withToken:(NSString *)token timestart:(NSString *)timestart  timeend:(NSString *)timeend;

-(void)requireonPrev:(void (^)())prev success:(void (^)(NSDictionary* response))success unavaliableNetwork:(void (^)())unavaliableNetwork timeout:(void (^)())timeout exception:(void (^)(NSString* message))exception;

@end
