//
//  NewFile.h
//  mts-iphone
//
//  Created by 李曜 on 15/5/12.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFile : NSObject
{
    
    NSString* _key;
    NSString* _url;
    NSString* _name;
    NSData* _data;
}


@property (nonatomic,copy) NSString* key;

@property (nonatomic,copy) NSString* url;

@property (nonatomic,copy) NSString* name;

@property (atomic,strong) NSData* data;

-(NSString*)getFilePathOfCache;

-(id) initWith:(NSDictionary*) dic;

-(NSMutableDictionary*) getUploadDictionary;

-(NSData*) getFileData;

-(void)saveDataToCache:(NSData*) data;

-(void)moveDataFromNameToUrl;

-(void)removeCache;

-(void)clearData;

+ (float ) folderSizeAtPath:(NSString*) folderPath;
@end
