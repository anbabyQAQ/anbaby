//
//  BPDetailViewController.m
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/8/18.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BPDetailViewController.h"
#import "PersonalInformationViewController.h"
#import "ChooseUser.h"
#import "User.h"
#import "UsersDao.h"
@interface BPDetailViewController ()<UIScrollViewDelegate,chooseUserDelegate>{
    NSInteger _type;
    User *_user;
}
@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;
@property (nonatomic, strong) UIView   *temp_view;

@property (nonatomic, strong) UITextField *right_btn;


@property (nonatomic, strong) UITableView *tempTableview;





@property (nonatomic, strong) UILabel *stateLabel;//状态
@property (nonatomic, strong) UILabel *electricityLabel;//电量

@property (nonatomic, strong) UILabel *highPressureLabel;
@property (nonatomic, strong) UILabel *lowPressureLabel;
@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, strong) UIImageView *pictureImageView;

@end

@implementation BPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"血压";
    
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
    
    ChooseUser *view = [[ChooseUser alloc]initWithFrame:CGRectMake(0, self.highPressureLabel.frame.origin.y + 40, SCR_W, 80)];
    view.user_delegate =self;
    [view setWithUserInfo:_users];
    [self.view addSubview:view];
    
    
}

- (void)setScantype:(NSInteger)scantype{
    _type = scantype;
    if (scantype==2) {
        _linktopManager.sdkHealthMoniterdelegate = self;
        [_linktopManager startOximetryTest];
        
    }
}



-(void)receiveBloodPressure:(int)Systolic_pressure andDiastolic_pressure:(int)Diastolic_pressure andHeart_beat:(int)Heart_beat
{
    
    self.highPressureLabel.text = [NSString stringWithFormat:@"血压：%d/%d",Systolic_pressure,Diastolic_pressure];
//    self.sysLab.text = [NSString stringWithFormat:@"收缩压%d",Systolic_pressure];
//    self.diaLab.text = [NSString stringWithFormat:@"舒张压%d",Diastolic_pressure];
//    self.heartLab.text = [NSString stringWithFormat:@"心率%d",Heart_beat];
    
    
}

-(void)initTempLayout{
    
    self.temp_lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    self.temp_lab.textAlignment=NSTextAlignmentLeft;
    self.temp_lab.text=@"血压";
    self.temp_lab.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.temp_lab.textColor = [UIColor blackColor];
    [self.view addSubview: self.temp_lab];
    
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W - 115, 20, 100, 20)];
    self.stateLabel.textAlignment=NSTextAlignmentRight;
    self.stateLabel.text=@"状态";
    self.stateLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.stateLabel.textColor = [UIColor blackColor];
    [self.view addSubview: self.stateLabel];
    
    
    self.electricityLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W/2 - 75, 20, 150, 20)];
    self.electricityLabel.textAlignment=NSTextAlignmentCenter;
    self.electricityLabel.text=@"仪器用电量";
    self.electricityLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.electricityLabel.textColor = [UIColor blackColor];
    [self.view addSubview: self.electricityLabel];
    
    
    self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, SCR_W - 40, SCR_H/667 *150)];
    self.pictureImageView.image = [UIImage imageNamed:@"Yosemite01.jpg"];
    [self.view addSubview:self.pictureImageView];
    
    
    self.highPressureLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.pictureImageView.frame.origin.y + self.pictureImageView.frame.size.height + 20, 150, 20)];
    self.highPressureLabel.textAlignment=NSTextAlignmentLeft;
    self.highPressureLabel.text=@"血压：";
    self.highPressureLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.highPressureLabel.textColor = [UIColor blackColor];
    [self.view addSubview: self.highPressureLabel];
    
    
//    self.lowPressureLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W - 165, self.highPressureLabel.frame.origin.y, 150, 20)];
//    self.lowPressureLabel.textAlignment=NSTextAlignmentCenter;
//    self.lowPressureLabel.text=@"低压：";
//    self.lowPressureLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
//    self.lowPressureLabel.textColor = [UIColor blackColor];
//    [self.view addSubview: self.lowPressureLabel];
    
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
    PersonalInformationViewController *pserson  = [[PersonalInformationViewController alloc] init];
    [self.navigationController pushViewController:pserson animated:YES];
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
