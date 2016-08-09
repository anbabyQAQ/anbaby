//
//  MineViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSInteger titleButtonInteger;//用来记录导航栏button点击次数
}
@property (weak, nonatomic) IBOutlet UITableView *mineTableView;
//导航栏下拉弹出tableView
@property (weak, nonatomic) IBOutlet UITableView *dropDownTableView;

@property(nonatomic, strong)NSArray *mineArray;
@property(nonatomic, strong)NSArray *dropDownArray;
@property(nonatomic, strong)UIButton *titleButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownTopView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mineArray = @[@"个人信息",@"我的亲友",@"退出登录"];
    self.dropDownArray = @[@"我的",@"老爸",@"老妈"];
    self.mineTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.dropDownTableView.separatorStyle =UITableViewCellSelectionStyleNone;
    [self addTitleButton];
    titleButtonInteger = 0;
}
-(void)addTitleButton{

    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(0, 0, 100, 44);
    [self.titleButton setTitle:@"照片" forState:UIControlStateNormal];
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
        if (self.dropDownArray.count > 4) {
            self.dropDownTableView.frame = CGRectMake(kScreenWidth / 2 - 50, 64, 100, 200);
        }else{
            self.dropDownTableView.frame = CGRectMake(kScreenWidth / 2 - 50, 64, 100, self.dropDownArray.count * 50);
        }
    }
}

-(void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([tableView isEqual:self.dropDownTableView]) {
       cell.textLabel.text = self.dropDownArray[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else{
       cell.textLabel.text = self.mineArray[indexPath.row];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self.dropDownTableView]) {
        self.dropDownTableView.hidden = YES;
        titleButtonInteger++;
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self.dropDownTableView]) {
        return 40;
    }else{
    
        return 80;
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
