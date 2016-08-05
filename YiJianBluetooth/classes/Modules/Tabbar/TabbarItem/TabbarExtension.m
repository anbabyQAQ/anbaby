//
//  TabbarExtension.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TabbarExtension.h"
#import <objc/runtime.h>

@implementation TabbarExtension

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@implementation UITabBar (XZMTabbarExtension)

static NSString *AssociatedButtonKey;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzled_layoutSubviews));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton  *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
        if (!centerButton) {
            centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            centerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            
            
            objc_setAssociatedObject(self, &AssociatedButtonKey, centerButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        [self addSubview:centerButton];
    }
    
    return self;
}

- (void)swizzled_layoutSubviews
{
    [self swizzled_layoutSubviews];
    
    [self setValue:[NSValue valueWithCGRect:self.bounds] forKeyPath:@"_backgroundView.frame"];
    
    UIButton  *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
    
    
    centerButton.bounds = CGRectMake(0, 0, centerButton.currentBackgroundImage.size.width, centerButton.currentBackgroundImage.size.height);
    CGFloat buttonW = self.frame.size.width / (self.items.count);
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;
    int index = 0;
    
    CGFloat heightDifference = centerButton.currentBackgroundImage.size.height - self.frame.size.height;
    if (heightDifference < 0)
        centerButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    else
    {
        CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        center.y = center.y - heightDifference/2.0;
        centerButton.center = center;
    }
    
    //    centerButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    for (UIView *chidView in self.subviews) {
        if ([chidView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            buttonX = index *buttonW;
            chidView.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
            if (index == 2) {
                //                index++;
                
                //                chidView.frame = CGRectMake(buttonX-10, -10, buttonW+20, buttonH+20);
            }
            index++;
            
        }
    }
}

- (void)setUpTabBarCenterButton:(void ( ^ _Nullable )(UIButton * _Nullable centerButton ))centerButtonBlock
{
    centerButtonBlock(objc_getAssociatedObject(self, &AssociatedButtonKey));
}

@end
