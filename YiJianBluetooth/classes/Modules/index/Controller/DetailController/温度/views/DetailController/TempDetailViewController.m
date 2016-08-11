//
//  TempDetailViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TempDetailViewController.h"
#import "MAThermometer.h"
#import "User.h"
#import "UsersDao.h"
#import "SegmentScroll.h"
#import "PersonalInformationViewController.h"

#define Kuser_imgW 60;
@interface TempDetailViewController ()<UITextFieldDelegate,UIScrollViewDelegate,userScrollDelegate>{
    UILabel *_temp;
}
@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;
@property (nonatomic, strong) UIView   *temp_view;

@property (nonatomic, strong) UITextField *right_btn;


@property (nonatomic, strong) UITableView *tempTableview;

@property (nonatomic, strong) MAThermometer * thermometer1;


@property (nonatomic, strong) SegmentScroll *scroll;
@property (nonatomic, strong) NSMutableArray *users;
@end

@implementation TempDetailViewController

- (NSMutableArray *)users {
    if (_users == nil) {
        _users = [[NSMutableArray alloc]init];
    }
    return _users;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initwithScroll];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"测量体温";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTempLayout];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self registerForKeyboardNotifications];
    
//    [self initwithScroll];
}

- (void)initwithScroll{
    
    _users = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];

    _scroll = [[SegmentScroll alloc] initWithFrame:CGRectMake(0, 270, SCR_W, 90)];
    [_scroll setWithUserInfo:_users];
    _scroll.user_delegate = self;
    
    [self.view addSubview:_scroll];
    
}

- (void)callBackIndex:(NSInteger)index {
    if (index-100 == _users.count) {
        //添加用户信息；

        PersonalInformationViewController *pserson  = [[PersonalInformationViewController alloc] init];
        [self.navigationController pushViewController:pserson animated:YES];
    }else{
        //选取用户添加记录
        
    }
}

- (void)keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
}

- (void)keyboardWasHidden:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSTimeInterval timeInterval = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:timeInterval animations:^{
        
    }];
}

- (void)keyboardHide
{
    [self.view endEditing:YES];
}


#pragma mark textview键盘问题
// textview键盘问题
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) initTempLayout{
    self.temp_lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    self.temp_lab.textAlignment=NSTextAlignmentLeft;
    self.temp_lab.text=@"体温";
    self.temp_lab.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.temp_lab.textColor = [UIColor grayColor];
    [self.view addSubview: self.temp_lab];
    
    
    _temp_view = [[UIView alloc] initWithFrame:CGRectMake(110, 50, 100, 150)];
    _temp_view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.temp_view.layer.masksToBounds = YES;
    self.temp_view.layer.cornerRadius = 6.0;
    self.temp_view.layer.borderWidth = 1.0;
    self.temp_view.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_temp_view];
    
    
    _thermometer1 = [[MAThermometer alloc] initWithFrame:_temp_view.bounds];
    [_thermometer1 setMaxValue:42];
    [_thermometer1 setMinValue:35];
    _thermometer1.glassEffect = YES;
//    int x = arc4random() % 8+35;
//    int y = arc4random()%10;
//    _thermometer1.curValue = x+y*0.1;
    [_temp_view addSubview:_thermometer1];
    
    _temp = [[UILabel alloc] initWithFrame:CGRectMake(220, 150, 80, 20)];
    _temp.textAlignment=NSTextAlignmentLeft;
    _temp.text=[NSString stringWithFormat:@"_ _℃"];
    _temp.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    _temp.textColor = [UIColor grayColor];
    [self.view addSubview: _temp];
    
    
    _right_btn = [[UITextField alloc] initWithFrame:CGRectMake(SCR_W-70, 20, 65, 20)];
    _right_btn.placeholder = @"手动录入";
    _right_btn.delegate =self;
    _right_btn.textColor = [UIColor grayColor];
    _right_btn.textAlignment = NSTextAlignmentCenter;
    _right_btn.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];;
    _right_btn.layer.masksToBounds = YES;
    _right_btn.layer.cornerRadius = 3.0;
    _right_btn.layer.borderWidth = 1.0;
    _right_btn.layer.borderColor = [[UIColor grayColor] CGColor];
    _right_btn.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:_right_btn];
    
    
    _startTest_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startTest_btn.frame = CGRectMake(20, SCR_H-NAVIGATION_HEIGHT-70, SCR_W-40, 50);
    [_startTest_btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _startTest_btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_startTest_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_startTest_btn setTitle:@"保存记录" forState:(UIControlStateNormal)];
    self.startTest_btn.layer.masksToBounds = YES;
    self.startTest_btn.layer.cornerRadius = 6.0;
    self.startTest_btn.layer.borderWidth = 1.0;
    self.startTest_btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_startTest_btn];
    
    
    
}

-(void)clickBtn:(id)sender{
   //缓存
    
    [self.navigationController popViewControllerAnimated:YES];

    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    _temp.text=[NSString stringWithFormat:@"%@℃",textField.text];
    _thermometer1.curValue = [_temp.text floatValue];


}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
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
