//
//  GuanYuWoMenViewController.m
//  Nurse
//
//  Created by Sandro on 15/10/21.
//  Copyright (c) 2015年 Sandro. All rights reserved.
//

#import "GuanYuWoMenViewController.h"

@interface GuanYuWoMenViewController (){
    NSString *youkonngStr;
    NSString *phone;
    NSString *personPWD;
}
@property (weak, nonatomic) IBOutlet UILabel *meLabel;

@end

@implementation GuanYuWoMenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];

    self.meLabel.text = @"优秀的团队";
    
}

- (void)BackAc{
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
