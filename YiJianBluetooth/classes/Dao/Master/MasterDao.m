//
//  MasterDao.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/31.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "MasterDao.h"
#import "LKDBHelper.h"

@implementation MasterDao

+(BOOL)saveMasterInfo:(Master *)master{

    LKDBHelper *globalHelper = [LKDBHelper getUsingLKDBHelper];
    BOOL success = [globalHelper insertToDB:master];
    return success;
    
}

+(NSArray *)getMaster{
    NSMutableArray *data_array = [Master searchWithWhere:nil orderBy:nil offset:0 count:9999];
    if (data_array.count>0) {
        return data_array;
    }
    return nil;
}

+(Master *)getMasterByAid:(NSNumber *)aid{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:aid forKey:@"aid"];
    NSMutableArray *data_array = [Master searchWithWhere:dic orderBy:nil offset:0 count:9999];
    if (data_array.count>0) {
        Master *master = [data_array lastObject];
        return master;
    }
    return nil;
}

+(BOOL)clearMaster{
    BOOL success = [Master deleteWithWhere:nil];
    return success;
    
}

+(BOOL)updateMaster:(Master *)master Byaid:(NSNumber *)aid{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:aid forKey:@"aid"];
    BOOL success = [Master updateToDB:master where:dic];
    return success;
}


@end
