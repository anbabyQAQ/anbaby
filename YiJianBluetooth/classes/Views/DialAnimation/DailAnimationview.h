//
//  DailAnimationview.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/24.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailAnimationview : UIView



@property (nonatomic, assign) CGFloat percent; // 百分比 0 - 100
@property (nonatomic, strong) UIImage *bgImage; // 背景图片
@property (nonatomic, strong) NSString *text; // 文字



@end
