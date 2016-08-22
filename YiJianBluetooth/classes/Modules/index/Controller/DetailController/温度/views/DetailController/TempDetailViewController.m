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
#import "PersonalInformationViewController.h"
#import "ChooseUser.h"
#import "BlockUIAlertView.h"

#define Kuser_imgW 60;
@interface TempDetailViewController ()<UITextFieldDelegate,UIScrollViewDelegate,chooseUserDelegate>{
    UILabel *_temp;
    NSInteger _type;
    User *_user;
}
@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;
@property (nonatomic, strong) UIView   *temp_view;

@property (nonatomic, strong) UITextField *right_btn;


@property (nonatomic, strong) UITableView *tempTableview;

@property (nonatomic, strong) MAThermometer * thermometer1;


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
    
    [self initLeftBarButtonItem];
    [self initrightBarButtonItem:@"重新测量" action:@selector(measureTemp)];
}


-(void)initrightBarButtonItem:(NSString*)title action:(SEL)action {
    
    
    MyCustomButton *mapbutton = [MyCustomButton buttonWithType:UIButtonTypeCustom];
    [mapbutton setFrame:CGRectMake(0, 0, 60, 44)];
    
    [mapbutton setTitle:title forState:(UIControlStateNormal)];
    mapbutton.titleLabel.font = [UIFont systemFontOfSize:text_size_small];
    
    CGSize titleSize = [mapbutton.titleLabel sizeThatFits:CGSizeMake(60, 44)];
    [mapbutton setTitleColor:UIColorFromRGB(0x0097ff) forState:(UIControlStateNormal)];
    [mapbutton setMyButtonContentFrame:CGRectMake(60 - titleSize.width, 10, titleSize.width, 25)];
    [mapbutton addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:mapbutton];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)measureTemp{
    if (_type==2) {
        [_linktopManager startThermometerTest];
        
    }
}

- (void)backToSuper{
    [_linktopManager endThermometerTest];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)initwithScroll{
    
    _users = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
    
    ChooseUser *view = [[ChooseUser alloc]initWithFrame:CGRectMake(0, 270, SCR_W, 80)];
    view.user_delegate =self;
    [view setWithUserInfo:_users];
    [self.view addSubview:view];
    
    
}

- (void)setScantype:(NSInteger)scantype{
    _type = scantype;
    if (scantype==2) {
        _linktopManager.sdkHealthMoniterdelegate = self;
        [_linktopManager startThermometerTest];

    }
}

-(void)receiveThermometerData:(double)temperature
{
  
    NSString *temperaturestr =[NSString stringWithFormat:@"%.1f℃",temperature];
    NSLog(@"%@",temperaturestr);
    _thermometer1.curValue = temperaturestr.floatValue;
    _temp.text = temperaturestr;
    
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
    self.temp_lab.textColor = [UIColor blackColor];
    [self.view addSubview: self.temp_lab];
    
    
    _temp_view = [[UIView alloc] initWithFrame:CGRectMake(SCR_W/2-30, 50, 60, 150)];
    _temp_view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.temp_view.layer.masksToBounds = YES;
    self.temp_view.layer.cornerRadius = 6.0;
    self.temp_view.layer.borderWidth = 1.0;
    self.temp_view.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_temp_view];
    
    
    _thermometer1 = [[MAThermometer alloc] initWithFrame:CGRectMake(10, 0, 40, 150)];
    [_thermometer1 setMaxValue:40];
    [_thermometer1 setMinValue:30];
    _thermometer1.glassEffect = YES;
//    int x = arc4random() % 8+35;
//    int y = arc4random()%10;
//    _thermometer1.curValue = x+y*0.1;
    _thermometer1.arrayColors = @[UIColorFromRGB(0xc62828)];
    [_temp_view addSubview:_thermometer1];
    
    _temp = [[UILabel alloc] initWithFrame:CGRectMake(220, 150, 80, 20)];
    _temp.textAlignment=NSTextAlignmentLeft;
    _temp.text=[NSString stringWithFormat:@"_ _℃"];
    _temp.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    _temp.textColor = [UIColor grayColor];
    [self.view addSubview: _temp];
    
    
    _right_btn = [[UITextField alloc] initWithFrame:CGRectMake(SCR_W-80, 23, 75, 20)];
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    passwordImage.image = [UIImage imageNamed:@"pencil_edit"];
    
    _right_btn.leftView = passwordImage;
    _right_btn.leftViewMode = UITextFieldViewModeAlways;
    _right_btn.placeholder = @"手动录入";
    _right_btn.delegate =self;
    _right_btn.textColor = [UIColor blackColor];
    _right_btn.textAlignment = NSTextAlignmentLeft;
    _right_btn.font = [UIFont systemFontOfSize:text_size_smaller];;
    _right_btn.layer.masksToBounds = YES;
    _right_btn.layer.cornerRadius = 3.0;
    _right_btn.layer.borderWidth = 1.0;
    _right_btn.layer.borderColor = [UIColorFromRGB(0xf3f3f3) CGColor];
    _right_btn.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:_right_btn];
    
    
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


- (void)textFieldDidEndEditing:(UITextField *)textField{
    _temp.text=[NSString stringWithFormat:@"%@℃",textField.text];
    _thermometer1.curValue = [_temp.text floatValue];


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
