//
//  UsersDao.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "UsersDao.h"
#import "LKDBHelper.h"

@implementation UsersDao

+(BOOL) saveUserInfo:(User*) user{
    
    LKDBHelper *globalHelper = [LKDBHelper getUsingLKDBHelper];
    BOOL success = [globalHelper insertToDB:user];
    return success;
    
}

+(User *)getUserInfoByName:(NSString *)name{
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:name forKey:@"name"];
    NSMutableArray *data_array = [User searchWithWhere:dic orderBy:nil offset:0 count:1];
    
    if (data_array) {
        User *result = [data_array lastObject];
        return result;
    }
    return nil;
}

+(User *)getUserInfoByName:(NSString *)name Byuid:(NSString *)uid{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:name forKey:@"name"];
    if (uid) {
        [dic setObject:uid forKey:@"uid"];
    }

    NSMutableArray *data_array = [User searchWithWhere:dic orderBy:nil offset:0 count:1];
    
    if (data_array) {
        User *result = [data_array lastObject];
        return result;
    }
    return nil;
}

+(NSArray *)getAllUsers{
    NSMutableArray *data_array = [User searchWithWhere:nil orderBy:nil offset:0 count:9999];
    return data_array;
}

+(BOOL)clearUsers{
   BOOL success = [User deleteWithWhere:nil];
    return success;

}

+(BOOL)clearUserInfoByName:(NSString *)name{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:name forKey:@"name"];
    BOOL success = [User deleteWithWhere:dic];
    return success;
}

+(BOOL)updateUser:(User *)user ByName:(NSString *)name{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:name forKey:@"name"];
    BOOL success = [User updateToDB:user where:dic];
    return success;
}
+(BOOL)updateUser:(User *)user ByName:(NSString *)name Byuid:(NSString *)uid{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:name forKey:@"name"];
    [dic setObject:uid forKey:@"uid"];

    BOOL success = [User updateToDB:user where:dic];
    return success;
}


@end
