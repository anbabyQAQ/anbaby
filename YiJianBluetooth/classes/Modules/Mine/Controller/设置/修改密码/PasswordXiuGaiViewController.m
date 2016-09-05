//
//  PasswordXiuGaiViewController.m
//  Nurse
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 Sandro. All rights reserved.
//

#import "PasswordXiuGaiViewController.h"

@interface PasswordXiuGaiViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    
    NSString *phone;
    NSString *personPWD;
    NSString *newPwd;
    
  
}
@property (weak, nonatomic) IBOutlet UITextField *newpassword1;

@property (weak, nonatomic) IBOutlet UITextField *newpassword2;

@property (weak, nonatomic) IBOutlet UITextField *yuanPassword;

@property (weak, nonatomic) IBOutlet UIButton *passwordButton;


@end

@implementation PasswordXiuGaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self initLeftBarButtonItem];
    
    self.newpassword1.delegate = self;
    self.newpassword1.secureTextEntry = YES;
    self.newpassword1.returnKeyType = UIReturnKeyDone;
    self.newpassword2.delegate = self;
    self.newpassword2.secureTextEntry = YES;
    self.newpassword2.returnKeyType = UIReturnKeyDone;
    self.yuanPassword.delegate = self;
    self.yuanPassword.returnKeyType = UIReturnKeyDone;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    _passwordButton.layer.cornerRadius = 3;
}

#pragma mark ======导航栏左侧返回按钮点击事件=======
-(void)BackAc{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========添加手势点击事件
-(void)tapAction:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _yuanPassword) {
        [_newpassword1 becomeFirstResponder];
    } else if (textField == _newpassword1){
        [_newpassword2 becomeFirstResponder];
    } else{
        [_newpassword2 resignFirstResponder];
    }
    return YES;
}

#pragma mark ======修改密码按钮点击事件=====
- (IBAction)chagePasswordButtonAction:(id)sender {
    
    if ([self.yuanPassword.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        
        if ([self.newpassword1.text isEqualToString:@""]&&[self.newpassword2.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入不少于六位密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }else{
            
            if (self.newpassword1.text.length < 6 && self.newpassword2.text.length < 6) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码不能为少于六位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                
                if (![self.newpassword2.text isEqualToString:self.newpassword1.text]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您两次输入密码不一致，请重新输入密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }else{
                    
                    
                 
                    
                }
                
            }
            
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
