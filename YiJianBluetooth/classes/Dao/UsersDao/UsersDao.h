//
//  UsersDao.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UsersDao : NSObject

+(BOOL)saveUserInfo:(User*) user;

+(User *)getUserInfoByName:(NSString *)name;

+(User *)getUserInfoByName:(NSString *)name Byuid:(NSString *)uid;


+(NSArray *)getAllUsers;

+(BOOL)clearUsers;

+(BOOL)clearUserInfoByName:(NSString *)name;

+(BOOL)updateUser:(User *)user ByName:(NSString *)name;

+(BOOL)updateUser:(User *)user ByName:(NSString *)name Byuid:(NSString *)uid;


@end
