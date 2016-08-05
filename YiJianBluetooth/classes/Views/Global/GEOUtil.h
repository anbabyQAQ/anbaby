//
//  GEOUtil.h
//  mts-iphone
//
//  Created by 李曜 on 15/6/24.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GEOUtil : UITableViewCell


+(NSString*) GeoDescribeWithLat:(double)lat andLon:(double)lon andOffset:(BOOL) isOffseted andDescribe:(NSString*)describe;


@end
