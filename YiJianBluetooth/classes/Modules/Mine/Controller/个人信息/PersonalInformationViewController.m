//
//  PersonalInformationViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "User.h"
#import "UsersDao.h"

@interface PersonalInformationViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
{

    UIPickerView *_PickerView;
    NSInteger pickInterger;
    
    NSString *heightString;
    NSString *weightString;
    NSString *ageString;
    NSString *sexString;
}

@property(nonatomic, strong)UIView *writeView;
@property(nonatomic, strong)UIView *toumingView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet UIButton *heightButton;

@property (weak, nonatomic) IBOutlet UIButton *weightButton;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;


@property(nonatomic, strong)NSMutableArray *heightArray;
@property(nonatomic, strong)NSMutableArray *weightArray;
@property(nonatomic, strong)NSMutableArray *ageArray;



//性别


@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIButton *grilButton;
@property (weak, nonatomic) IBOutlet UIButton *boyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grilOrBoyButtonWidth;
//(51)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grilButtonToplabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boyButtonTopGril;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonTopBoy;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLeftBarButtonItem];


    self.title = @"个人信息";
    self.sexView.hidden = YES;
    sexString = @"";
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.borderColor = UIColorFromRGB(0xf75601).CGColor;
    self.nextButton.layer.borderWidth = 1;
    pickInterger = 0;
    [self addArray];
    
    
    [self addTextField:self.nameTextField];
    [self addTextField:self.phoneTextField];
    

    
}

- (BOOL)navigationShouldPopOnBackButton {
    
    
//    if ([self.nameTextField.text isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"名字为空将无法为您保存" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];
//    }
    User *user = [User new];
    user.name = self.nameTextField.text;
    user.weight = [self.weightButton.titleLabel.text doubleValue];
    user.height = [self.heightButton.titleLabel.text doubleValue];
    user.age = [self.ageButton.titleLabel.text integerValue];
    user.phone = self.phoneTextField.text;
    
    user.gender = kGender_FeMale;
    user.headIcon=[UIImage imageNamed:@"person_gril2"];
    
    if ([self.sexButton.titleLabel.text isEqualToString:@"男"]) {
        user.gender=kGender_Male;
        user.headIcon=[UIImage imageNamed:@"person_boy4"];

    }
    
    if (![DataUtil isEmptyString:user.name] ) {
        if ([UsersDao getUserInfoByName:user.name]) {
            [UsersDao clearUserInfoByName:user.name];
        }
        [UsersDao saveUserInfo:user];
    }
    
    
    return YES;
}


-(void)addTextField:(UITextField *)textField{

    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.grilOrBoyButtonWidth.constant = kScreenWidth / 375 * 116;
    self.labelTopView.constant = kScreenHeight / 667 *51;
    self.grilButtonToplabel.constant = kScreenHeight / 667 * 51;
    self.boyButtonTopGril.constant = kScreenHeight / 667 * 51;
    self.nextButtonTopBoy.constant = kScreenHeight / 667 * 51;
    
}
-(void)addArray{

    for (int i = 80; i < 241; i++) {
        [self.heightArray addObject:@(i)];
    }
    
    
    for (int i = 15; i < 121; i++) {
        [self.weightArray addObject:@(i)];
    }
    
    for (int i = 1; i < 101; i++) {
        [self.ageArray addObject:@(i)];
    }
}


#pragma mark =======性别按钮点击事件
- (IBAction)sexButtonAction:(id)sender {

    self.navigationController.navigationBarHidden = YES;
    [self.view endEditing:YES];
    self.sexView.hidden = NO;
}

- (IBAction)grilButtonAction:(id)sender {
    
    [self.grilButton setImage:[UIImage imageNamed:@"person_gril1.png"] forState:(UIControlStateNormal)];
    [self.boyButton setImage:[UIImage imageNamed:@"person_boy4.png"] forState:(UIControlStateNormal)];
    sexString = @"女";
}
- (IBAction)boyButtonAction:(id)sender {
    [self.grilButton setImage:[UIImage imageNamed:@"person_gril2.png"] forState:(UIControlStateNormal)];
    [self.boyButton setImage:[UIImage imageNamed:@"person_boy3.png"] forState:(UIControlStateNormal)];
    sexString = @"男";
    
    
}
- (IBAction)nextButtonAction:(id)sender {
    
    
    if ([sexString isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有选择性别，放弃修改点击左上角关闭按钮" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }else{
        [self.sexButton setTitle:sexString forState:(UIControlStateNormal)];
        
        self.sexView.hidden = YES;
        [self.grilButton setImage:[UIImage imageNamed:@"gril2.png"] forState:(UIControlStateNormal)];
        [self.boyButton setImage:[UIImage imageNamed:@"boy4.png"] forState:(UIControlStateNormal)];
        sexString = @"";
        
        self.navigationController.navigationBarHidden = NO;
    }
}
- (IBAction)guanbiButtonAction:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    sexString = @"";
    self.sexView.hidden = YES;
    [self.grilButton setImage:[UIImage imageNamed:@"person_gril2.png"] forState:(UIControlStateNormal)];
    [self.boyButton setImage:[UIImage imageNamed:@"person_boy4.png"] forState:(UIControlStateNormal)];
}

#pragma mark ======身高按钮点击事件
- (IBAction)heightButtonAction:(id)sender {
    
    pickInterger = 1;
    [self addPickView];
}

#pragma mark ======体重按钮点击事件
- (IBAction)weightButtonAction:(id)sender {
    
    pickInterger = 2;
    [self addPickView];

}
#pragma mark ======年龄按钮点击事件
- (IBAction)ageButtonAction:(id)sender {
    pickInterger = 3;
    [self addPickView];

}
-(void)addPickView{
    [self.view endEditing:YES];
    self.navigationController.navigationBarHidden = YES;
    _toumingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _toumingView.backgroundColor = UIColorFromRGB(0x777777);
    _toumingView.alpha = 0.4;
    [self.view addSubview:_toumingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toumingAction:)];
    [_toumingView addGestureRecognizer:tap];
    
    _writeView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 220, [UIScreen mainScreen].bounds.size.width, 220)];
    _writeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_writeView];
    
    
    UILabel *danweiLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, 5, 80, 30)];
    danweiLabel.textColor = UIColorFromRGB(0x777777);
    if (pickInterger == 1) {
        danweiLabel.text = @"单位：cm";
    }else if (pickInterger == 2){
    
        danweiLabel.text = @"单位：kg";
    }else if (pickInterger == 3){
    
        danweiLabel.hidden = YES;
    }
    [_writeView addSubview:danweiLabel];
    
    //添加取消按钮
    UIButton *quxiaoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 40, 30)];
    [quxiaoButton setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [quxiaoButton addTarget:self action:@selector(pickerViewQuXiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writeView addSubview:quxiaoButton];
    
    //添加确定按钮
    UIButton *quedingButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40 , 5, 40, 30)];
    [quedingButton setTitle:@"确定" forState:UIControlStateNormal];
    [quedingButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [quedingButton addTarget:self action:@selector(pickerViewQueDingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writeView addSubview:quedingButton];
    
    //添加pickView
    _PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
    _PickerView.backgroundColor = UIColorFromRGB(0xeeeeee);
    _PickerView.delegate = self;
    _PickerView.dataSource = self;
    [_writeView addSubview:_PickerView];
    
}

#pragma mark =======弹出pickView 上面取消按钮点击事件=======
-(void)pickerViewQuXiaoAction:(UIButton *)sender{
    self.navigationController.navigationBarHidden = NO;
    [_toumingView removeFromSuperview];
    [_writeView removeFromSuperview];
    
}
#pragma mark =======弹出pickView 上面取确定钮点击事件=======
-(void)pickerViewQueDingAction:(UIButton *)sender{
    self.navigationController.navigationBarHidden = NO;
    if (pickInterger == 1) {
        
        [self.heightButton setTitle:heightString forState:(UIControlStateNormal)] ;
    }else if (pickInterger == 2){
        
        [self.weightButton setTitle:weightString forState:(UIControlStateNormal)] ;
    }else{
        [self.ageButton setTitle:ageString forState:(UIControlStateNormal)] ;
    }

    [_toumingView removeFromSuperview];
    [_writeView removeFromSuperview];
}
#pragma mark ======添加在类型弹出灰色背景上的手势========
-(void)toumingAction:(UITapGestureRecognizer *)sender{
    self.navigationController.navigationBarHidden = NO;
    [_toumingView removeFromSuperview];
    [_writeView removeFromSuperview];
    
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickInterger == 1) {
        return self.heightArray.count;
    }else if (pickInterger == 2){
    
        return self.weightArray.count;
    }else if (pickInterger == 3){
    
        return self.ageArray.count;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickInterger == 1) {
        NSString *height = [NSString stringWithFormat:@"%@",self.heightArray[row]];
        return height;
    }else if (pickInterger == 2){
    
        NSString *weight = [NSString stringWithFormat:@"%@", self.weightArray[row]];
        return weight;
    }else{
    
        NSString *age = [NSString stringWithFormat:@"%@",self.ageArray[row]];
        return age;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
   
    if (pickInterger == 1) {
    
        heightString = [NSString stringWithFormat:@"%@",self.heightArray[row]];
    }else if (pickInterger == 2){
        weightString = [NSString stringWithFormat:@"%@", self.weightArray[row]];
    }else{
        ageString = [NSString stringWithFormat:@"%@",self.ageArray[row]];
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:22]];
        [pickerLabel setTextColor:UIColorFromRGB(0x010000)];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


#pragma mark -==========textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    return YES;
}


-(NSMutableArray *)heightArray{

    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

-(NSMutableArray *)weightArray{
    if (!_weightArray) {
        _weightArray = [NSMutableArray array];
    }
    return _weightArray;
}
-(NSMutableArray *)ageArray{

    if (!_ageArray) {
        _ageArray = [NSMutableArray array];
    }
    return _ageArray;
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
