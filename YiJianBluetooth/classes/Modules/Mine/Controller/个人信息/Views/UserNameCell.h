//
//  UserNameCell.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/27.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class UserNameCell;
@protocol UserNameCellDelegate <NSObject>

- (void)callbackUserName:(NSString *)name;

@end
@interface UserNameCell : UITableViewCell<UITextFieldDelegate>{
    BOOL _edit;
    NSString *_userinfo;
    
    UILabel *_name;
    UITextField *_nameTextField;
}
@property (strong, nonatomic) id<UserNameCellDelegate> delegate;

-(instancetype)initWithUsername:(NSString *)username;

-(CGFloat)getHeightOfCell;


@end
