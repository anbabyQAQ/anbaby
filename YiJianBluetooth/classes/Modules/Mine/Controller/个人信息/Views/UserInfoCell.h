//
//  UserInfoCell.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/27.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoCell;
@protocol UserInfoCellDelegate <NSObject>

- (void)callbackUserName:(NSString *)name;

@end
@interface UserInfoCell : UITableViewCell{
    BOOL _edit;
    NSString *_userinfo;
    NSString *_usertitle;
    
    UILabel *_name;

    UILabel *_title;
}

@property (strong, nonatomic) id<UserInfoCellDelegate> delegate;

-(instancetype)initWithUserTitle:(NSString *)usertitle andUserinfo:(NSString *)userinfo  andreuseIdentifier:(NSString *)reuseIdentifier;

-(CGFloat)getHeightOfCell;

- (void)setuserInfo:(NSString *)userinfo;


@end
