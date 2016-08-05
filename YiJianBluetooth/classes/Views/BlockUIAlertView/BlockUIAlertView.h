//
//  BlockUIAlertView.h
//  mts-iphone
//
//  Created by tyl on 15/7/10.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger);

@interface BlockUIAlertView : UIAlertView

@property(nonatomic,copy)AlertBlock block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles;

@end


