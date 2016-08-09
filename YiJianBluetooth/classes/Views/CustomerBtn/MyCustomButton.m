//
//  MyCustomButton.m
//  mts-iphone
//
//  Created by lizhe on 15/11/6.
//  Copyright © 2015年 中国电信. All rights reserved.
//

#import "MyCustomButton.h"

@implementation MyCustomButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        return self;
    }
    
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        return self;
    }
    
    return nil;
}

- (void)setMyButtonImageFrame : (CGRect) rect {
    _rect_image = rect;//图片的位置大小
}
- (void)setMyButtonContentFrame : (CGRect) rect {
    _rect_title = rect;//文本的位置大小
}

-(CGRect) imageRectForContentRect:(CGRect)contentRect {
    return _rect_image;
}

-(CGRect) titleRectForContentRect:(CGRect)contentRect {
    return _rect_title;
}
@end
