//
//  BlockUIAlertView.m
//  mts-iphone
//
//  Created by tyl on 15/7/10.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "BlockUIAlertView.h"

@implementation BlockUIAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    
    if (self) {
        self.block = _block;
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.block(buttonIndex);
}


@end