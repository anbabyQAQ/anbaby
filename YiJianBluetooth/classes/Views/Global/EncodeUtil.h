//
//  EncodeUtil.h
//  mts-iphone
//
//  Created by 李曜 on 15/5/29.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
@interface EncodeUtil : NSObject
+(NSString *)HmacSha1:(NSString *)key data:(NSString *)data;

+(NSString *)HmacSha256:(NSString *)key data:(NSString *)data;


@end
