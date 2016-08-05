//
//  VedioUtil.m
//  mts-iphone
//
//  Created by 李曜 on 15/6/26.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "VedioUtil.h"

#import <AVFoundation/AVFoundation.h>
@implementation VedioUtil

+(UIImage *)imageWithVideo:(NSURL *)videoURL
{
    // 根据视频的URL创建AVURLAsset
    AVURLAsset* asset = [[AVURLAsset alloc]
                         initWithURL:videoURL options:nil];
    // 根据AVURLAsset创建AVAssetImageGenerator对象
    AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc]
                                  initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    // 定义获取0帧处的视频截图
    CMTime time = CMTimeMake(0, 10);
    NSError* error = nil;
    CMTime actualTime;
    // 获取time处的视频截图
    CGImageRef image = [gen copyCGImageAtTime:time
                                   actualTime:&actualTime error:&error];
    // 将CGImageRef转换为UIImage
    UIImage* thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}@end
