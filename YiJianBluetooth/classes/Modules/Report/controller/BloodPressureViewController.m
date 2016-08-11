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

@interface BloodPressureViewController (){
    BrokenLine *_barChartView;
    
    
    
    PieChart *_pieChart1;
    PieChart *_pieChart2;
    PieChart *_pieChart3;
    PieChart *_pieChart4;
    
    
}
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation BloodPressureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addScrollview];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
