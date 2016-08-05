//
//  FileUtil.m
//  mts-iphone
//
//  Created by 李曜 on 15/5/7.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil


+(BOOL) exist:(NSString*)path isDirectory:(BOOL) isdic;
{
    NSFileManager* manager=[NSFileManager defaultManager];
    return [manager fileExistsAtPath:path isDirectory:isdic];


}

+(BOOL) deleteFile:(NSString*)path{
 NSError* error;
 NSFileManager* manager=[NSFileManager defaultManager];
 if ([manager removeItemAtPath:path error:&error] != YES){
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        return NO;
    
    }else {
        return YES;
    }
}


+(NSData*) convertFileToData:(NSString*)path{
    return [[NSData alloc]initWithContentsOfFile:path];
}


+(NSString*) getMineType:(NSString* ) path{

    NSArray*b=[path componentsSeparatedByString:@"."];
    NSString* suffix=@"unknown";
    if(b.count>1){
        suffix=[b objectAtIndex:b.count-1];
    }
    if([suffix compare:@"txt"]==NSOrderedSame||[suffix compare:@"log"]==NSOrderedSame){
    
        return @"text/plain";
    
    
    
    }else if([suffix compare:@"html"]==NSOrderedSame||[suffix compare:@"htm"]==NSOrderedSame){
    
    
        return @"text/html";
    
    }else if([suffix compare:@"jpg"]==NSOrderedSame||[suffix compare:@"jpeg"]==NSOrderedSame||[suffix compare:@"png"]==NSOrderedSame||[suffix compare:@"gif"]==NSOrderedSame){
    
        return @"image/jpeg";
    
    
    }else if([suffix compare:@"pdf"]==NSOrderedSame){
    
         return @"application/pdf";
    
    }else if([suffix compare:@"doc"]==NSOrderedSame){
        
        
        return @"application/msword";
        
    }else if([suffix compare:@"docx"]==NSOrderedSame){
        
        
        return @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        
    }
    
    
    
    else if([suffix compare:@"ppt"]==NSOrderedSame){
        
        
        return @"application/vnd.ms-powerpoint";
        
    }else if([suffix compare:@"pptx"]==NSOrderedSame){
        
        
        return @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
        
    }else if([suffix compare:@"xls"]==NSOrderedSame){
        
        
        return @"application/vnd.ms-excel";
        
    }else if([suffix compare:@"xlsx"]==NSOrderedSame){
        
        
        return @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        
    }else if([suffix compare:@"mp4"]==NSOrderedSame){
        
        
        return @"video/mp4";
        
    }
    return nil;

    
    
    

}
@end
