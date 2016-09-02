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

#import "MasterDao.h"
#import "Master.h"


@interface MineViewController ()<UIAlertViewDelegate>
{
    mUser *_muser;
    Master *_master;
}

@property(nonatomic, strong)NSArray *mineArray;
@property(nonatomic, strong)NSMutableArray *dropDownArray;
@property(nonatomic, strong)UIButton *titleButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownTopView;

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

    NSMutableArray *arr =  [NSMutableArray arrayWithArray:[MasterDao getMaster]];
    if (arr) {
        _master = [arr lastObject];
        
        if (_master) {
            if (_master.users.count>0) {
                _muser = [_master.users firstObject];
            }else{
                [self getData];
            }
            
        }
    }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x62828);
    
    self.mineArray = @[@"个人信息",@"我的亲友",@"设置"];

}

#pragma mark ========我的亲友列表请求
-(void)getData{
    
 
    NSString *aid = [NSString stringWithFormat:@"%ld", (long)_master.aid];
    GetUserFamilyThred *family = [[GetUserFamilyThred alloc] initWithAid:aid withToken:_master.token];
    [family requireonPrev:^{
        [self showHud:@"请求中..." onView:self.view];
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

            //抽屉刷新
            
            [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
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
   GuanYuWoMenViewController *guanyuVC = [[GuanYuWoMenViewController alloc] init];
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
