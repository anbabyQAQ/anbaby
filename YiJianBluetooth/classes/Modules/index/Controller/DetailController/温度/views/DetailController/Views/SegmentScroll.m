//
//  SegmentScroll.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "SegmentScroll.h"
#import "User.h"

@implementation SegmentScroll

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

- (void)setWithUserInfo:(NSArray *)users{
    
    self.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(60*(users.count+1), 80);
    
    
    for (int i=0; i<users.count+1; i++) {
        UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(60*i, 0, 60, 80)];
        userView.userInteractionEnabled=YES;
        
        
        
        if (i<users.count) {
            
            userView.tag = 100+i;
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
            User *user = users[i];
            imageview.image = user.headIcon;
            [userView addSubview:imageview];
            
            UILabel    *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 20)];
            lable.font = [UIFont systemFontOfSize:text_size_between_smallAndSmaller];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor grayColor];
            lable.text=user.name;
            [userView addSubview:lable];
        }else{
            
            userView.tag = 100+i;
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 50, 50)];
            imageview.image = [UIImage imageNamed:@"tabBar_publish_icon"];
            imageview.userInteractionEnabled=YES;
            [userView addSubview:imageview];
            
        }
        

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
        [userView addGestureRecognizer:tapGesture];

        
        [self addSubview:userView];
        
    }

    
}

-(void)Actiondo:(id)sender{
    
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;

    
    if ([self.user_delegate respondsToSelector:@selector(callBackIndex:)]) {
        [self.user_delegate callBackIndex: recognizer.view.tag];
    }

}
@end
