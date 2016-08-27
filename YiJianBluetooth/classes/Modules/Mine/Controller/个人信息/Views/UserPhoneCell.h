//
//  UserPhoneCell.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/27.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserPhoneCell;
@protocol UserPhoneCellDelegate <NSObject>

- (void)callbackUserPhone:(NSString *)phone;

@end
@interface UserPhoneCell : UITableViewCell<UITextFieldDelegate>{
    BOOL _edit;
    NSString *_userinfo;
    
    UILabel *_name;
    UITextField *_nameTextField;
}
@property (strong, nonatomic) id<UserPhoneCellDelegate> delegate;

-(instancetype)initWithUserPhone:(NSString *)phone;

-(CGFloat)getHeightOfCell;

@end
