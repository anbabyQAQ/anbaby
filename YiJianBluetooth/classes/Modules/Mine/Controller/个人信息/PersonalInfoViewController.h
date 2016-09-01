//
//  PersonalInfoViewController.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/26.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
#import "UserNameCell.h"
#import "UserPhoneCell.h"
#import "UserSexCell.h"
#import "UserInfoCell.h"
#import "Master.h"

@interface PersonalInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserNameCellDelegate,UserPhoneCellDelegate,UserSexCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *stretchView;
@property (weak, nonatomic) IBOutlet UITableView *infotableview;

@property (strong , nonatomic) UIButton *saveBtn;

@property (strong , nonatomic) UserNameCell *namecell;
@property (strong , nonatomic) UserPhoneCell *phonecell;
@property (strong , nonatomic) UserSexCell *sexcell;
@property (strong , nonatomic) UserInfoCell *weightcell;
@property (strong , nonatomic) UserInfoCell *heihgtcell;
@property (strong , nonatomic) UserInfoCell *agecell;

@property (strong , nonatomic) NSString *uid;
@property (strong , nonatomic) NSString *mineString;//用来区分是从我的 个人信息进来还是从我的亲友进来


-(instancetype)initWithUser:(User *)user WithMaster:(Master *)master andEditable:(BOOL)editable;


@end
