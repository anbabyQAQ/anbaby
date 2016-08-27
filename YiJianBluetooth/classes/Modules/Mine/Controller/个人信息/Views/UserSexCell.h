//
//  UserSexCell.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/27.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserSexCell ;
@protocol UserSexCellDelegate <NSObject>

- (void)callbackusersex:(BOOL)usersex;

@end
@interface UserSexCell : UITableViewCell{
    BOOL _edit;
    
    UILabel *_name;

}

@property(assign ,nonatomic)BOOL sex_bool;
@property(nonatomic, strong)UIButton *boyButton;
@property(nonatomic, strong)UIButton *grilButton;

@property(assign, nonatomic) id<UserSexCellDelegate>delegate;


-(instancetype)initWithUserSex:(BOOL )usersex;

-(CGFloat)getHeightOfCell;

@end
