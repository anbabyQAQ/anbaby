//
//  FileUtil.h
//  mts-iphone
//
//  Created by 李曜 on 15/5/7.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+(BOOL) exist:(NSString*)path isDirectory:(BOOL) isdic;

+(BOOL) deleteFile:(NSString*)path;

+(NSData*) convertFileToData:(NSString*)path;

+(NSString*) getMineType:(NSString* ) path;

@end
