//
//  UILabel+BezierAnimation.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/24.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BezierAnimation)


//label 上的数字  从某一个值变化到 另一个值  －  （动画） －  //默认 数字后 没有字符 拼接 ~~~~~  也可拼接 字符，调用此方法


- (void)animationFromnum:(float )fromNum toNum:(float )toNum duration:(float )duration ConnectText:(NSString *)text;



@end
