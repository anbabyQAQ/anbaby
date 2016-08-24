//
//  TYLBezier.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/24.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef struct
{
    float x;
    float y;
} TYLPoint;


@interface TYLBezier : NSObject

@property (nonatomic,assign) TYLPoint wsStart;
@property (nonatomic,assign) TYLPoint wsFirst;
@property (nonatomic,assign) TYLPoint wsSecond;
@property (nonatomic,assign) TYLPoint wsEnd;


- (TYLPoint )pointWithdt:(float )dt;


@end
