//
//  Master.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/31.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mUser.h"


@interface Master : NSObject

@property (assign, nonatomic) NSInteger aid;
@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *pass;
@property (assign, nonatomic) NSInteger isbanned;
@property (assign, nonatomic) NSInteger registerType;

@property (strong, nonatomic) NSMutableArray<mUser*> *users;

@property (strong, nonatomic) NSString *uid;

//标记当前  显示用户的名字 or 亲友的名字；
@property (strong, nonatomic) NSString *showName;


@end
