//
//  LogUtil.m
//  mts-iphone
//
//  Created by 李曜 on 15/6/2.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "LogUtil.h"

@implementation LogUtil

+(void)write:(NSString*)str{

    NSString *dicName=[NSString stringWithFormat:@"/%@",[DateUtil DateFormatToString:[NSDate date] WithFormat:@"yyyy-MM-dd"]];
    NSString *fileName = [NSString stringWithFormat:@"%@/log.txt",dicName] ;
//    [CTSIGlobalUtil checkDirectory:dicName]
    if (0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
        //查找文件，如果不存在，就创建一个文件
        
        if (![fileManager fileExistsAtPath:filePath])
        {
            
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        if (fileHandle == nil){
            return;
        }
        
        [fileHandle seekToEndOfFile]; // 将节点跳到文件的末尾
        
        NSString* content=[NSString stringWithFormat:@"\n[%@] %@",[DateUtil DateFormatToString:[NSDate date] WithFormat:@"yyyy-MM-dd hh:mm:ss"],str];
        NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
        
        [fileHandle writeData:stringData]; //追加写入数据
        
        [fileHandle closeFile];
        
        NSLog(@"%@",content);
    }
}

+(void)write:(NSString*) key value:(NSString*)value{
    NSString* content=[NSString stringWithFormat:@"%@:%@",key,value];
    [LogUtil write:content];
    NSLog(@"%@",content);

}
@end
