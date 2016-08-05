//
//  GEOUtil.m
//  mts-iphone
//
//  Created by 李曜 on 15/6/24.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "GEOUtil.h"

@implementation GEOUtil

+(NSString*) GeoDescribeWithLat:(double)lat andLon:(double)lon andOffset:(BOOL) isOffseted andDescribe:(NSString*)describe{

    if([DataUtil isEmptyString:describe])
        return  @"查看位置";
    else
        return describe;




}
@end
