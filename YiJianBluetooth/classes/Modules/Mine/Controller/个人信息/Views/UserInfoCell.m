//
//  UserInfoCell.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/27.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithUserTitle:(NSString *)usertitle andUserinfo:(NSString *)userinfo  andreuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _usertitle = usertitle;
        _userinfo  = userinfo;
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
        _name.text = _usertitle;
        _name.textAlignment= NSTextAlignmentLeft;
        _name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_name];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, SCR_W - 190, 30)];
        
        NSLog(@"%@",_userinfo);
        if (_userinfo !=nil ) {
            _title.text = _userinfo;
        }else{
            _title.text = @"未填写";
        }
        _title.textAlignment= NSTextAlignmentRight;
        _title.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_title];
        
        
    }
    return self;
}
- (void)setuserInfo:(NSString *)userinfo{
    _usertitle = userinfo;
    if (userinfo) {
        _title.text = userinfo;
    }
    
}



@end
