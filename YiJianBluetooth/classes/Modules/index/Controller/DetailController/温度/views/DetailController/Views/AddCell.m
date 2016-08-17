//
//  AddCell.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/16.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "AddCell.h"

@implementation AddCell{
    UIImageView *_imageview;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 50, 50)];
        _imageview.image = [UIImage imageNamed:@"tabBar_publish_icon"];
        _imageview.userInteractionEnabled=YES;

        [self.contentView addSubview:_imageview];

    }
    return self;
}

@end
