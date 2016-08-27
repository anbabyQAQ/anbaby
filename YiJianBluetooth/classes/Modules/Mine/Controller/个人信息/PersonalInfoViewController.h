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

@interface PersonalInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserNameCellDelegate,UserPhoneCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *stretchView;
@property (weak, nonatomic) IBOutlet UITableView *infotableview;

@property (strong , nonatomic) UIButton *saveBtn;

@property (strong , nonatomic) UserNameCell *namecell;
@property (strong , nonatomic) UserPhoneCell *phonecell;


-(instancetype)initWithUser:(User *)user andEditable:(BOOL)editable;


@end
