//
//  TabbarExtension.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarExtension : UIView

@end


// ———————————————————— 如果图片与文字分开请使用类扩展 ——————————————————————

@interface UITabBar (XZMTabbarExtension)

// 设置个性化中间按钮
- (void)setUpTabBarCenterButton:(void ( ^ _Nullable )(UIButton * _Nullable centerButton ))centerButtonBlock;

@end