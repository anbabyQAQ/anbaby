//
//  User.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface User : NSObject
/**
 *  ID
 */
//@property (nonatomic,assign) unsigned char ID;
/**
 *  ID for icon
 */
@property (nonatomic,strong) NSString  *uid;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,retain) NSDate *date;







/**
 *   array contains the items which is the subclass of 'DailyCheckItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicDlc;

/**
 *   array contains the items which is the subclass of 'ECGInfoItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicECG;

/**
 *   array contains the items which is the subclass of 'SLMItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicSLM;

/**
 *   array contains the items which is the subclass of 'SPO2InfoItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicSPO2;

/**
 *   array contains the items which is the subclass of 'TempInfoItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicTemp;

/**
 *   array contains the items which is the subclass of 'GlucoseInfoItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicGlucose;

/**
 *   array contains the items which is the subclass of 'BPI'
 */
@property (nonatomic,retain) NSMutableDictionary *dicBPI;

/**
 *   array contains the items which is the subclass of 'BPCheckItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicBPCheck;

/**
 *   array contains the items which is the subclass of 'PedInfoItem'
 */
@property (nonatomic,retain) NSMutableDictionary *dicPed;

/**
 *  Unknown
 */
@property (nonatomic,retain) NSMutableArray *detailSPO2Array;





@end
