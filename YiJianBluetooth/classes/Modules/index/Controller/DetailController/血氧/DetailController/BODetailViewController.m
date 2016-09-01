//
//  BODetailViewController.m
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/8/18.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BODetailViewController.h"
#import "ChooseUser.h"
#import "User.h"
#import "UsersDao.h"
#import "PersonalInfoViewController.h"
@interface BODetailViewController ()<UIScrollViewDelegate,chooseUserDelegate>{
    NSInteger _type;
    User *_user;
}


@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;

@property (nonatomic, strong) UILabel *electricityLabel;//电量

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, strong) UIImageView *pictureImageView;

@end

@implementation BODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"血氧";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTempLayout];
    
    [self initLeftBarButtonItem];
    [self initrightBarButtonItem:@"重新测量" action:@selector(measureTemp)];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initwithScroll];
}

- (void)measureTemp{
    if (_type==2) {
        [_linktopManager startOximetryTest];
        
    }
}

- (void)backToSuper{
    [_linktopManager endOximetryTest];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initwithScroll{
    
    _users = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
    
    ChooseUser *view = [[ChooseUser alloc]initWithFrame:CGRectMake(0, self.resultLabel.frame.origin.y + 40, SCR_W, 80)];
    view.user_delegate =self;
    [view setWithUserInfo:_users];
    [self.view addSubview:view];
    
    
}

-(void)initTempLayout{
    
    self.temp_lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    self.temp_lab.textAlignment=NSTextAlignmentLeft;
    self.temp_lab.text=@"血氧";
    self.temp_lab.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.temp_lab.textColor = [UIColor blackColor];
    [self.view addSubview: self.temp_lab];
    
//    self.electricityLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W - 165, 20, 150, 20)];
//    self.electricityLabel.textAlignment=NSTextAlignmentCenter;
//    self.electricityLabel.text=@"仪器用电量";
//    self.electricityLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
//    self.electricityLabel.textColor = [UIColor blackColor];
//    [self.view addSubview: self.electricityLabel];
    
    
    self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, SCR_W - 40, SCR_H/667 *150)];
    self.pictureImageView.image = [UIImage imageNamed:@"blood_bo.jpg"];
    [self.view addSubview:self.pictureImageView];
    
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.pictureImageView.frame.origin.y + self.pictureImageView.frame.size.height + 20, 200, 20)];
    self.resultLabel.textAlignment=NSTextAlignmentLeft;
    self.resultLabel.text=@"血氧：";
    self.resultLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.resultLabel.textColor = [UIColor blackColor];
    [self.view addSubview: self.resultLabel];
    
    _startTest_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startTest_btn.frame = CGRectMake(20, SCR_H-NAVIGATION_HEIGHT-70, SCR_W-40, 50);
    [_startTest_btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _startTest_btn.backgroundColor = UIColorFromRGB(0xc62828);
    [_startTest_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_startTest_btn setTitle:@"保存记录" forState:(UIControlStateNormal)];
    self.startTest_btn.layer.masksToBounds = YES;
    self.startTest_btn.layer.cornerRadius = 6.0;
    self.startTest_btn.layer.borderWidth = 1.0;
    self.startTest_btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_startTest_btn];
}
- (void)setScantype:(NSInteger)scantype{
    _type = scantype;
    if (scantype==2) {
        _linktopManager.sdkHealthMoniterdelegate = self;
        [_linktopManager startOximetryTest];
        
    }
}

-(void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate
{
    
    self.resultLabel.text = [NSString stringWithFormat:@"血氧：%.1f％",oxy];
    
//    self.oxyHeartRate.text = [NSString stringWithFormat:@"%d",heartRate];
    
}

-(void)clickBtn:(id)sender{
    //缓存
    
    //    [_user.dicTemp  obj]
    if (_user) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_users.count>0) {
            [self showToast:@"请选择测量人"];
        }else{
            [self showToast:@"请添加测量人"];
        }
    }
    
    
}
#pragma mark ChooseUser代理

- (void)callBaceAddUser{
  PersonalInfoViewController *info = [[PersonalInfoViewController alloc] initWithUser:nil WithMaster:nil andEditable:YES];
    [self.navigationController pushViewController:info animated:YES];

    

}

-(void)callBackUser:(User *)user{
    //选取用户添加记录
    _user = user;
    
}
- (NSMutableArray *)users {
    if (_users == nil) {
        _users = [[NSMutableArray alloc]init];
    }
    return _users;
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
