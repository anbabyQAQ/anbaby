//
//  UserNameCell.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/27.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "UserNameCell.h"

@implementation UserNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithUsername:(NSString *)username{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserNameCell"];
    if (self) {
        _userinfo = username;
        _name = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 30)];
        _name.text = @"姓名";
        _name.textAlignment= NSTextAlignmentLeft;
        _name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_name];
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCR_W/2+20, 3, SCR_W/2-30, 38)];
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.font = [UIFont fontWithName:@"Arial" size:14.0f];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.textAlignment = NSTextAlignmentRight;
        _nameTextField.placeholder = @"请输入姓名";
        if (username) {
            _nameTextField.text = username;
        }
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.delegate = self;
        _nameTextField.userInteractionEnabled=YES;
        [self.contentView addSubview:_nameTextField];
        

        
    }
    return self;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [_nameTextField becomeFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        return NO;
    }

    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(callbackUserName:)]) {
            [self.delegate callbackUserName:textField.text];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [_nameTextField resignFirstResponder];
    return YES;
    
}

-(CGFloat)getHeightOfCell{
    return 58;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
