//
//  SegmentScroll.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentScroll;

@protocol userScrollDelegate <NSObject>

-(void)callBackIndex:(NSInteger)index;

@end


@interface SegmentScroll : UIScrollView{
    NSMutableArray *_array;
}

@property (nonatomic, assign) id<userScrollDelegate> user_delegate;


- (void)setWithUserInfo:(NSArray *)users;

@end
