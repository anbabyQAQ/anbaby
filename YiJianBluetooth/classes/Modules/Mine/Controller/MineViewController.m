//
//  MineViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "MineViewController.h"
#import "GuanYuWoMenViewController.h"
#import "FamilyViewController.h"
#import "LoginViewController.h"
#import "UsersDao.h"
#import "mUser.h"
#import "GetUserFamilyThred.h"
#import "PersonalInfoViewController.h"

#import "SetViewController.h"

#import "MasterDao.h"
#import "Master.h"
#import "DropDownMenu.h"

@interface MineViewController ()<UIAlertViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    mUser *_muser;
    Master *_master;
}

@property(nonatomic, strong)NSArray *mineArray;
@property(nonatomic, strong)NSMutableArray *dropDownArray;
@property(nonatomic, strong)UIButton *titleButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownTopView;



@property (nonatomic, strong) NSArray *user_classifys;
@property (nonatomic, strong) NSArray *user_cates;

@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, weak) DOPDropDownMenu *menu;

@end

@implementation MineViewController

-(NSMutableArray *)dropDownArray{
    if (_dropDownArray==nil) {
        _dropDownArray = [[NSMutableArray alloc] init];
    }
    return _dropDownArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    _master = [MasterDao getMasterByAid:[[NSUserDefaults standardUserDefaults] objectForKey:@"master_aid"]];
   
    if (_master) {
        if (_master.users.count>0) {
            _muser = [_master.users firstObject];
            NSMutableArray *user_arr = [[NSMutableArray alloc]init];
            for (mUser *m in _master.users) {
                [user_arr addObject:m.name];
            }
            self.user_classifys = [NSArray arrayWithArray:user_arr];
            [self menuReloadData];
            
            
            [_master.users enumerateObjectsUsingBlock:^(mUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                mUser *m = (mUser*)obj;
                if ([m.name isEqualToString:_master.showName]) {
                    [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:idx]];
                    _muser=m;
                }
            }];
            
        }else{
            [self getData];
        }
    }
    
    

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x62828);
    
    self.mineArray = @[@"个人信息",@"我的亲友",@"设置"];

    [self addTitleButton];
}

#pragma mark 导航栏中间title按钮
-(void)addTitleButton{
    self.user_classifys = @[@"我的"];
    
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44 andSuperView:self.view];
    menu.delegate = self;
    menu.dataSource = self;
    
    _menu = menu;
    
    self.navigationItem.titleView = _menu;

}


- (void)menuReloadData
{
    [_menu reloadData];
}

#pragma mark 下拉抽屉代理实现


- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.user_classifys.count;
    }else {
        return 0;
    }
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.user_classifys[indexPath.row];
    }  else {
        return 0;
    }
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 || indexPath.column == 1) {
        return [NSString stringWithFormat:@"我的－头像"];
    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return [NSString stringWithFormat:@"我的－头像"];
    }
    return nil;
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return  nil;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            return self.user_cates[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
    
    if (_user_classifys.count>indexPath.row) {
        NSString *name = [_user_classifys objectAtIndex:indexPath.row];
        _master.showName = name;
        [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
    }
    
    
    [_master.users enumerateObjectsUsingBlock:^(mUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        mUser *m = (mUser*)obj;
        if ([m.name isEqualToString:_master.showName]) {
            _muser = m;
        }
    }];

}

#pragma mark ========我的亲友列表请求
-(void)getData{
    
 
    NSString *aid = [NSString stringWithFormat:@"%ld", (long)_master.aid];
    GetUserFamilyThred *family = [[GetUserFamilyThred alloc] initWithAid:aid withToken:_master.token];
    [family requireonPrev:^{
        [self showHud:@"数据请求中..."];
    } success:^(NSMutableArray *response) {
        NSLog(@"%@", response);
        [self hideHud];
        
        if (response.count>0) {
            NSMutableArray *muser_arr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in response) {
                mUser *muser = [[mUser alloc] initWith:dic];
                [muser_arr addObject:muser];
            }
            _master.users = muser_arr;

            _muser = [_master.users firstObject];
            [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];

            //抽屉刷新
            NSMutableArray *user_arr = [[NSMutableArray alloc]init];
            for (mUser *m in _master.users) {
                [user_arr addObject:m.name];
            }
            self.user_classifys = [NSArray arrayWithArray:user_arr];
            [self menuReloadData];

            [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0]];
            
            
        }else{
            [_master.users removeAllObjects];
            _muser = nil;
            [self showToast:@"请添加个人信息~"];
            
            [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
            
        }
        
    } unavaliableNetwork:^{
        [self hideHud];
        [self showToast:@"网络未连接"];
    } timeout:^{
        [self hideHud];
        [self showToast:@"网络连接超时"];
    } exception:^(NSString *message) {
        [self hideHud];
        if (message) {
            [self showToast:message];
        }else{
            [self showToast:@"位置错误"];
        }
    }];
    
    
    
}


-(void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];
    
}
#pragma mark =======点击个人信息
- (IBAction)personButtonAction:(id)sender {
   // PersonalInformationViewController *person = [PersonalInformationViewController new];
    
    
    PersonalInfoViewController *guanyuVC = [[PersonalInfoViewController alloc] initWithUser:_muser WithMaster:_master andEditable:YES];
    guanyuVC.uid = _muser.uid;
    guanyuVC.mineString = @"我的";
    guanyuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guanyuVC animated:YES];
}

#pragma mark =======点击我的亲友
- (IBAction)FamilyButtonAction:(id)sender {
    FamilyViewController *family = [FamilyViewController new];
    family.master = _master;
    family.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:family animated:YES];
}

#pragma mark ===========关于我们==============
- (IBAction)guanYuWoMenButtonAction:(id)sender {
   SetViewController *guanyuVC = [[SetViewController alloc] init];
//    PersonalInfoViewController *guanyuVC = [[PersonalInfoViewController alloc] init];

    guanyuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guanyuVC animated:YES];
}
#pragma mark =========退出登录============
- (IBAction)tuiChuDengLuButtonAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1006;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1006) {
        if (buttonIndex == 1) {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"master_aid"];
            
            LoginViewController *login = [LoginViewController new];
            SBNvc *nav = [[SBNvc alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
