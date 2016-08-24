//
//  UILabel+BezierAnimation.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/24.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "UILabel+BezierAnimation.h"

#import "TYLBezier.h"

#define KMaxTimes 100

@implementation UILabel (BezierAnimation)

NSString  *connectText;  //pinjie 拼接text

NSMutableArray *totlePoints; //纪录所有的点。

TYLBezier *bezier;  //通过 改变bezier 函数的参数  （也就是 四个 控制点）可以改变动画的样式 －

float _duration; // 动画 间隔
float _fromNum;
float _toNum;

float _lastTime; //纪录每一个点的 时刻

int _index;


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self _initBezier];
        [self _cleanVars];
    }
    
    return self;
}


- (void)_cleanVars{
    
    _lastTime = 0;
    _index = 0;
    self.text = @"0";
    
}


//初始化 控制点
- (void)_initBezier{
    
    
    bezier = [[TYLBezier alloc] init];
}


- (void)animationFromnum:(float)fromNum toNum:(float)toNum duration:(float)duration ConnectText:(NSString *)text{
    
    [self _cleanVars];
    
    _duration = duration;
    _fromNum = fromNum;
    _toNum = toNum;
    
    connectText = text;
    
    
    totlePoints = [NSMutableArray array];
    float dt = 1.0 / (KMaxTimes - 1);
    for (NSInteger i = 0; i < KMaxTimes; i ++ ) {
        
        TYLPoint point = [bezier  pointWithdt:dt * i];
        
        
        float currTime = point.x * _duration;
        float currValue = point.y * (_toNum - _fromNum) + _fromNum;
        
        NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:currTime] , [NSNumber numberWithFloat:currValue], nil];
        [totlePoints addObject:array];
        
    }
    
    [self changeNumberBySelector];
    
}

- (void)changeNumberBySelector {
    if (_index>= KMaxTimes) {
        self.text = [NSString stringWithFormat:@"%.0f%@",_toNum,connectText];
        return;
    } else {
        NSArray *pointValues = [totlePoints objectAtIndex:_index];
        _index++;
        float value = [(NSNumber *)[pointValues objectAtIndex:1] intValue];
        float currentTime = [(NSNumber *)[pointValues objectAtIndex:0] floatValue];
        float timeDuration = currentTime - _lastTime;
        _lastTime = currentTime;
        self.text = [NSString stringWithFormat:@"%.0f%@",value,connectText];
        [self performSelector:@selector(changeNumberBySelector) withObject:nil afterDelay:timeDuration];
    }
}




@end
