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
#import "PostLoginThread.h"

@interface LoginViewController ()<UITextFieldDelegate>
{

    NSString *JianPanNum;
    CGSize kbSize;
}

@property (weak, nonatomic) IBOutlet UITextField *NumberTextField;//账号

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//密码

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

//账号密码登陆错误弹出View
@property (weak, nonatomic) IBOutlet UIView *chongshiView;
//重试按钮
@property (weak, nonatomic) IBOutlet UIButton *chongshiButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    self.chongshiView.hidden = YES;
    self.chongshiButton.layer.cornerRadius = 5;
    self.loginButton.layer.cornerRadius = 5;
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self addTextField:self.NumberTextField];
    [self addTextField:self.passwordTextField];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if ([JianPanNum isEqualToString:@"0"]) {
        NSDictionary* info = [aNotification userInfo];
        //kbSize即為鍵盤尺寸 (有width, height)
        kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.15];
        
        //if (kScreenWidth == 320) {
            
            self.view.frame = CGRectMake(0, - kbSize.height + 150,kScreenWidth, kScreenHeight);

        [UIView commitAnimations];
    }
    
}

- (void)keyboardWillBeHidden{
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    JianPanNum = @"1";
    
}


#pragma mark ======登录按钮点击事件
- (IBAction)loginButtonAction:(id)sender {
    
    if ([self.NumberTextField.text isEqualToString:@""]) {
        
        [self showToast:@"请输入账号"];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
    
        [self showToast:@"请输入密码"];
        return;
    }

    PostLoginThread *login = [[PostLoginThread alloc] initWithMdn:self.NumberTextField.text withPassword:self.passwordTextField.text];
    [login requireonPrev:^{
        [self showHud:@"登录中..." onView:self.view];
    } success:^(NSDictionary *response) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"Login"];
        [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)addTextField:(UITextField *)textField{
    
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    
}
#pragma mark =========注册按钮点击事件==========
- (IBAction)registerButtonAction:(id)sender {
   
    
    RegisterViewController *regVC = [[RegisterViewController alloc] init];
    UINavigationController *addNavController = [[UINavigationController alloc] initWithRootViewController:regVC];
    [self presentViewController:addNavController animated:YES completion:nil];
    
}
#pragma mark =========重试按钮点击事件
- (IBAction)chongshiButtonAction:(id)sender {
    MainTabBarController *main = [MainTabBarController new];
    [self.navigationController pushViewController:main animated:YES];
}
#pragma maek =========忘记密码点击事件
- (IBAction)wangjiMiMaButtonAction:(id)sender {
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{

    JianPanNum = @"0";
}
    
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.NumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
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
