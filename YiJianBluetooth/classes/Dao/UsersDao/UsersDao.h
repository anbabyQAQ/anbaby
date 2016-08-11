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

+(NSArray *)getAllUsers;

+(BOOL)clearUsers;

+(BOOL)clearUserInfoByName:(NSString *)name;


@end
