//
//  UserSexCell.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/27.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "UserSexCell.h"

@implementation UserSexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

}

-(instancetype)initWithUserSex:(BOOL )usersex{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserSexCell"];
    if (self) {

        _name = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 30)];
        _name.text = @"性别";
        _name.textAlignment= NSTextAlignmentLeft;
        _name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_name];
    
        _sex_bool = usersex;
        
        self.grilButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.grilButton.frame = CGRectMake(SCR_W - 60, 0, 40, 40);
        self.grilButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.grilButton addTarget:self action:@selector(grilButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];


        [self addSubview:self.grilButton];
        
        
        self.boyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.boyButton.frame = CGRectMake(SCR_W - 120, 0, 40, 40);
        self.boyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.boyButton addTarget:self action:@selector(boyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];

        [self addSubview:self.boyButton];
        
        
        if (_sex_bool) {
            [self.grilButton setImage:[UIImage imageNamed:@"person_gril1.png"] forState:(UIControlStateNormal)];
            [self.boyButton setImage:[UIImage imageNamed:@"person_boy4.png"] forState:(UIControlStateNormal)];
        }else{
            [self.grilButton setImage:[UIImage imageNamed:@"person_gril2.png"] forState:(UIControlStateNormal)];
            [self.boyButton setImage:[UIImage imageNamed:@"person_boy3.png"] forState:(UIControlStateNormal)];
        }
    
    
    
    }
    
    return self;
    
    
}
-(void)grilButtonAction:(UIButton *)sender{
    
    [self.grilButton setImage:[UIImage imageNamed:@"person_gril1.png"] forState:(UIControlStateNormal)];
    [self.boyButton setImage:[UIImage imageNamed:@"person_boy4.png"] forState:(UIControlStateNormal)];
    _sex_bool = YES;
    [self usersexDelegate];

}
-(void)boyButtonAction:(UIButton *)sender{
    [self.grilButton setImage:[UIImage imageNamed:@"person_gril2.png"] forState:(UIControlStateNormal)];
    [self.boyButton setImage:[UIImage imageNamed:@"person_boy3.png"] forState:(UIControlStateNormal)];
    _sex_bool = NO;
    [self usersexDelegate];
}

- (void)usersexDelegate{
    if ([self.delegate respondsToSelector:@selector(callbackusersex:)]) {
        [self.delegate callbackusersex:_sex_bool];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
