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

+(Master *)getMaster{
    NSMutableArray *data_array = [Master searchWithWhere:nil orderBy:nil offset:0 count:9999];
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




@end
