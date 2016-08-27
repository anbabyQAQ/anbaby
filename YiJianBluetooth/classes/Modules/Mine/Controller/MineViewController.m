//
//  MineViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "MineViewController.h"
#import "GuanYuWoMenViewController.h"
#import "PersonalInformationViewController.h"
#import "FamilyViewController.h"
#import "LoginViewController.h"
#import "UsersDao.h"
#import "User.h"
#import "PersonalInfoViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    User *_user;
    NSInteger titleButtonInteger;//用来记录导航栏button点击次数
}
//导航栏下拉弹出tableView
@property (weak, nonatomic) IBOutlet UITableView *dropDownTableView;

@property(nonatomic, strong)NSArray *mineArray;
@property(nonatomic, strong)NSMutableArray *dropDownArray;
@property(nonatomic, strong)UIButton *titleButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownTopView;

@end

@implementation MineViewController

-(NSMutableArray *)dropDownArray{
    if (_dropDownArray==nil) {
        _dropDownArray = [[NSMutableArray alloc] init];
    }
    return _dropDownArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dropDownArray = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
    
    if (!_user && self.dropDownArray.count>0) {
        _user = [self.dropDownArray objectAtIndex:0];
    }
    [self.dropDownTableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x62828);
    

    self.mineArray = @[@"个人信息",@"我的亲友",@"设置"];

    
    self.dropDownTableView.separatorStyle =UITableViewCellSelectionStyleNone;
    self.dropDownTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self setExtraCellLineHidden:self.dropDownTableView];
    [self addTitleButton];
    titleButtonInteger = 0;
}

-(void)addTitleButton{

    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(0, 0, 100, 44);
    [self.titleButton setTitle:@"用户" forState:UIControlStateNormal];
    [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.titleButton titleLabel] setFont:[UIFont systemFontOfSize:52/3]];
    [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleButton setImage:[UIImage imageNamed:@"xialaImage"] forState:UIControlStateNormal];
    [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    self.navigationItem.titleView = _titleButton;
}

-(void)titleButtonClick:(UIButton *)sender{

    titleButtonInteger++;
    
    if (titleButtonInteger % 2 == 0) {
        titleButtonInteger = 0;
         self.dropDownTableView.hidden = NO;
        self.dropDownTableView.frame = CGRectMake(kScreenWidth / 2 - 50, -1000, 100, 200);
    }else{
        
        self.dropDownTableView.hidden = NO;
       
        self.dropDownTableView.frame = CGRectMake(kScreenWidth / 2 - 50, 0, 100, self.dropDownArray.count * 40);
        
    }
}

-(void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];
    
}
#pragma mark =======点击个人信息
- (IBAction)personButtonAction:(id)sender {
    PersonalInformationViewController *person = [PersonalInformationViewController new];
    person.user = _user;
    
    person.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:person animated:YES];
}

#pragma mark =======点击我的亲友
- (IBAction)FamilyButtonAction:(id)sender {
    FamilyViewController *family = [FamilyViewController new];
    family.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:family animated:YES];
}

#pragma mark ===========关于我们==============
- (IBAction)guanYuWoMenButtonAction:(id)sender {
//    GuanYuWoMenViewController *guanyuVC = [[GuanYuWoMenViewController alloc] init];
    PersonalInfoViewController *guanyuVC = [[PersonalInfoViewController alloc] init];

    guanyuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guanyuVC animated:YES];
}
#pragma mark =========退出登录============
- (IBAction)tuiChuDengLuButtonAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1006;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1006) {
        if (buttonIndex == 1) {
            LoginViewController *login = [LoginViewController new];
            [self presentViewController:login animated:YES completion:nil];
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dropDownArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    User *user = self.dropDownArray[indexPath.row];
    cell.textLabel.text = user.name;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    cell.textLabel.textColor = [UIColor darkTextColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if ([tableView isEqual:self.dropDownTableView]) {
        self.dropDownTableView.hidden = YES;
        titleButtonInteger++;
        
        _user = self.dropDownArray[indexPath.row];
        
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
