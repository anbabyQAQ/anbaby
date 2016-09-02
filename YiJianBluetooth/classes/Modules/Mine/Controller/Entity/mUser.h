//
//  mUser.h
//  YiJianBluetooth
//
//  Created by tyl on 16/9/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFile.h"

typedef enum
{
    kGender_FeMale,
    kGender_Male
}Gender_t;

typedef enum
{
    kAgeType_Children,
    kAgeType_Adult
}AgeType_t;

@interface mUser : NSObject


@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSString  *uid;


@property (nonatomic,retain) UIImage *headIcon;
//头像本地路径
@property (nonatomic, strong) NewFile *headIcon_file;

@property (nonatomic,assign) NSInteger weight;

@property (nonatomic,assign) NSInteger height;


@property (nonatomic,assign) NSNumber *number ;

@property (nonatomic,strong) NSString* age;
@property (nonatomic,assign) Gender_t gender;


@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSDate *birthdate;

-(instancetype)initWith:(NSDictionary*) dic;


-(NSDictionary*)dictionary;

@end
