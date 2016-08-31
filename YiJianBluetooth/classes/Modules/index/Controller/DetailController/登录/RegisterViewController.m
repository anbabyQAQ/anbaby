//
//  RegisterViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainTabBarController.h"
#import "GetRegisterThred.h"
#import "LoginViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    
    NSString *JianPanNum;
    CGSize kbSize;
}

@property (weak, nonatomic) IBOutlet UITextField *NumberTextField;//账号
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//密码
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:(UIBarButtonItemStylePlain) target:self action:@selector(BackAc)];
    
    self.registerButton.layer.cornerRadius = 5;
    [self addTextField:self.NumberTextField];
    [self addTextField:self.passwordTextField];
    
    [self initLeftBarButtonItem];
    
}

- (void)backToSuper {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        self.view.frame = CGRectMake(0, - kbSize.height + 200,kScreenWidth, kScreenHeight);
        
        [UIView commitAnimations];
    }
    
}

- (void)keyboardWillBeHidden{
    
    
    
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    JianPanNum = @"1";
    
}


-(void)addTextField:(UITextField *)textField{

    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    
}

-(void)BackAc{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ===============注册按钮点击事件
- (IBAction)registerButtonAction:(id)sender {
    if ([self.NumberTextField.text isEqualToString:@""]) {
        [self addAlert:@"请输入账号"];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [self addAlert:@"请输入密码"];
        return;
    }
    
    GetRegisterThred *thred = [[GetRegisterThred alloc] initWithUserName:self.NumberTextField.text withPassword:self.passwordTextField.text withType:@"-1"];
    [thred requireonPrev:^{
        [self showHud:@"注册中.." onView:self.view];

    } success:^(NSDictionary *response) {
        [self hideHud];

        [self showToast:@"注册成功"];
        
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

-(void)addAlert:(NSString *)alert{

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:alert delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertview show];
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
