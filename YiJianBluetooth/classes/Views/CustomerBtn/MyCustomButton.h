//
//  MyCustomButton.h
//  mts-iphone
//
//  Created by lizhe on 15/11/6.
//  Copyright © 2015年 中国电信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomButton : UIButton
{
    CGRect _rect_image;
    CGRect _rect_title;
}

- (void)setMyButtonImageFrame : (CGRect) rect;
- (void)setMyButtonContentFrame : (CGRect) rect;

@end
