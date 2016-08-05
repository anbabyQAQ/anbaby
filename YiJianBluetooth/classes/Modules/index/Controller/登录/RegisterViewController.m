//
//  RegisterViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:(UIBarButtonItemStylePlain) target:self action:@selector(BackAc)];
}

-(void)BackAc{

    [self.navigationController popViewControllerAnimated:YES];
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
