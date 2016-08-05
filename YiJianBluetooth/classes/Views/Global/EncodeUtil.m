//
//  EncodeUtil.m
//  mts-iphone
//
//  Created by 李曜 on 15/5/29.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "EncodeUtil.h"

@implementation EncodeUtil
+(NSString *)HmacSha1:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    return [[NSString alloc]initWithData:HMAC encoding:NSUTF8StringEncoding];
}


+(NSString *)HmacSha256:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    //sha1
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", cHMAC[i]];
    }
    NSLog(@"HmacSha256:%@",result);
    
    NSString* str_result=[NSString stringWithFormat:@"%@",result];
    return str_result;
}
@end
