//
//  BloodPressureViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BloodPressureViewController.h"
#import "BrokenLine.h"
#import "PieChart.h"

#import "UsersDao.h"
#import "User.h"
@interface BloodPressureViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BrokenLine *_barChartView;
    
    
    
    PieChart *_pieChart1;
    PieChart *_pieChart2;
    PieChart *_pieChart3;
    PieChart *_pieChart4;
    
    
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong)UIButton *titleButton;
@property(nonatomic, strong)UITableView *dropDownTableView;
@property(nonatomic, strong)NSMutableArray *dropDownArray;
@end

@implementation BloodPressureViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.dropDownArray = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addScrollview];
    [self initLeftBarButtonItem];

    self.view.backgroundColor = [UIColor whiteColor];
    //添加tableView
    [self addTablView];
    [self addTitleButton];
}

- (void)addScrollview{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, SCR_W, SCR_H); // frame中的size指UIScrollView的可视范围
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    // 隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    
    _barChartView = [[BrokenLine alloc] initWithFrame:CGRectMake(20, 10, SCR_W-40, 200) type:YES];
    [_barChartView updateDataBtnClick];
    _barChartView.LineChartView.descriptionText=@"血压折现图";
    
    [self.scrollView addSubview:_barChartView];
    
    
    _pieChart1 = [[PieChart alloc] initWithFrame:CGRectMake(20, 220+300*0, SCR_W-40, 300)];
    _pieChart2 = [[PieChart alloc] initWithFrame:CGRectMake(20, 220+300*1, SCR_W-40, 300)];
    _pieChart3 = [[PieChart alloc] initWithFrame:CGRectMake(20, 220+300*2, SCR_W-40, 300)];
    _pieChart4 = [[PieChart alloc] initWithFrame:CGRectMake(20, 220+300*3, SCR_W-40, 300)];
    
    [self.scrollView addSubview:_pieChart1];
    [self.scrollView addSubview:_pieChart2];
    [self.scrollView addSubview:_pieChart3];
    [self.scrollView addSubview:_pieChart4];
    
    //富文本
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"血压"];
    [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor orangeColor]} range:NSMakeRange(0, centerText.length)];
    _pieChart1.pieChartView.centerAttributedText = centerText;
    _pieChart2.pieChartView.centerAttributedText = centerText;
    _pieChart3.pieChartView.centerAttributedText = centerText;
    _pieChart4.pieChartView.centerAttributedText = centerText;
    
    _pieChart1.pieChartView.descriptionText=@"日-血压饼状图";
    _pieChart2.pieChartView.descriptionText=@"周-血压饼状图";
    _pieChart3.pieChartView.descriptionText=@"月-血压饼状图";
    _pieChart4.pieChartView.descriptionText=@"季度-血压饼状图";
    
    
    float bottom = 20.0;
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 220+300*4+bottom+NAVIGATION_HEIGHT);
    
    
}


#pragma mark ===========导航栏中间title按钮
-(void)addTitleButton{
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(0, 0, 100, 44);
    [self.titleButton setTitle:@"我的" forState:UIControlStateNormal];
    [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.titleButton titleLabel] setFont:[UIFont systemFontOfSize:52/3]];
    [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleButton setImage:[UIImage imageNamed:@"xialaImage"] forState:UIControlStateNormal];
    [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    self.navigationItem.titleView = _titleButton;
}

-(void)titleButtonClick:(UIButton *)sender{
    
    
    if (self.titleButton.selected) {
        self.dropDownTableView.hidden = YES;
        self.titleButton.selected = NO;
    }else{
        self.titleButton.selected = YES;
        self.dropDownTableView.hidden = NO;
        self.dropDownTableView.frame =CGRectMake(kScreenWidth / 2 - 50, 0,100, self.dropDownArray.count * 40);
    }
}

-(void)addTablView{
    
    self.dropDownArray = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
    self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 0,100, self.dropDownArray.count * 40) style:(UITableViewStylePlain)];
    self.dropDownTableView.showsVerticalScrollIndicator = NO;
    self.dropDownTableView.delegate =self;
    self.dropDownTableView.dataSource = self;
    [self.view addSubview:self.dropDownTableView];
    self.dropDownTableView.hidden = YES;
}
-(NSMutableArray *)dropDownArray{
    if (_dropDownArray==nil) {
        _dropDownArray = [[NSMutableArray alloc] init];
    }
    return _dropDownArray;
}


#pragma mark =============tableView代理
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
    
    self.dropDownTableView.hidden = YES;
    self.titleButton.selected = NO;
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
