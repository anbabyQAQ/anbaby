//
//  LoginViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainTabBarController.h"
@interface LoginViewController ()


@property (weak, nonatomic) IBOutlet UITextField *NumberTextField;//账号

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//密码

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    
}
#pragma mark ======登录按钮点击事件
- (IBAction)loginButtonAction:(id)sender {
    
}
#pragma mark =========注册按钮点击事件==========
- (IBAction)registerButtonAction:(id)sender {
    
    RegisterViewController *regVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
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
