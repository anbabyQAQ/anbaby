//
//  UIView+Extensions.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/24.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)



@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;


@end
