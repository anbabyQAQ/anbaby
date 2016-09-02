//
//  MasterDao.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/31.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Master.h"

@interface MasterDao : NSObject

+(BOOL)saveMasterInfo:(Master *)master;

+(NSArray *)getMaster;

+(Master*)getMasterByAid:(NSNumber *)aid;

+(BOOL)clearMaster;

+(BOOL)deleteMasterByAid:(NSNumber *)aid;


+(BOOL)updateMaster:(Master *)master Byaid:(NSNumber * )aid;



@end
