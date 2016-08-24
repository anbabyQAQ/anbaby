
//
//  TYLBezier.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/24.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TYLBezier.h"

@implementation TYLBezier


- (instancetype)init{
    
    if (self = [super init]) {
        
        
        [self _initPoints];
    }
    return self;
}

- (void)_initPoints{
    
    TYLPoint start;
    TYLPoint first;
    TYLPoint second;
    TYLPoint end;
    start.x = 0;
    start.y = 0;
    first.x = 0;
    first.y = 0.57;
    second.x = 0.44;
    second.y = 1;
    end.x = 1;
    end.y = 1;
    
    self.wsStart = start;
    self.wsFirst = first;
    self.wsSecond = second;
    self.wsEnd = end;
    
}


//贝塞尔 －
//y=y0·(1-t)³+3·y1·t·(1-t)²+3·y2·t²·(1-t)+y3·t³
//x=x0·(1-t)³+3·x1·t·(1-t)²+3·x2·t²·(1-t)+x3·t³


//贝塞尔的 四个 控制点
//（0 ， 0 ） (0 , 0.57) (0.44 , 1 ) (1 ,1);  //
// 还可以 设置  ease in ， ease out ，ease inout ，以及spring动画 。 有需要 联系840787626@qq.com



- (TYLPoint)pointWithdt:(float )dt{
    
    TYLPoint result;
    
    float t = 1 - dt;
    float tSqure = t * t;
    float tCube = t * tSqure;
    float dtSqure = dt * dt;
    float dtCube = dtSqure * dt;
    
    result.x = self.wsStart.x * tCube + 3 * self.wsFirst.x * dt * tSqure  +  3 * self.wsSecond.x * dtSqure * t + self.wsEnd.x * dtCube;
    result.y = self.wsStart.y * tCube + 3 * self.wsFirst.y * dt * tSqure  +  3 * self.wsSecond.y * dtSqure * t + self.wsEnd.y * dtCube;
    return result;
    
    
}



@end
