//
//  FanKui0ViewController.m
//  Nurse
//
//  Created by Sandro on 15/10/21.
//  Copyright (c) 2015年 Sandro. All rights reserved.
//

#import "FanKui0ViewController.h"

@interface FanKui0ViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    
    NSString *phone;
    NSString *personPWD;
    NSString *content;
}
@property (weak, nonatomic) IBOutlet UILabel *tiShiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shuziLabel;
@property (weak, nonatomic) IBOutlet UIButton *tiJiaoButton;

@end

@implementation FanKui0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户反馈";
    [self initLeftBarButtonItem];
    self.neirongTV.delegate = self;
    self.neirongTV.returnKeyType = UIReturnKeyDone;
    _tiShiLabel.hidden = NO;
    self.tiJiaoButton.layer.masksToBounds = YES;
    self.tiJiaoButton.layer.cornerRadius = 3;
}
-(void)textViewDidChange:(UITextView *)textView{
    _tiShiLabel.hidden = YES;
    
    if (textView.text.length > 500) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只限500字" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        _shuziLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)textView.text.length];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tijiaoAc:(id)sender {
    [self initLeftBarButtonItem];
}
@end
