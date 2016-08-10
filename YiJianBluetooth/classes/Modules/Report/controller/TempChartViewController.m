//
//  TempChartViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/10.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TempChartViewController.h"
#import "YiJianBluetooth-Bridging-Header.h"
#import "YiJianBluetooth-Swift.h"

@interface TempChartViewController ()<ChartViewDelegate>

@property (nonatomic, strong) BarChartView *barChartView;
@property (nonatomic, strong) BarChartData *data;

@end

@implementation TempChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加barChartView
    self.barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(20, 10, SCR_W-40, 300)];
    self.barChartView.delegate = self;//设置代理
    [self.view addSubview:self.barChartView];
    
    //基本样式
    self.barChartView.backgroundColor = [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    self.barChartView.noDataText = @"暂无数据";//没有数据时的文字提示
    self.barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
    self.barChartView.drawHighlightArrowEnabled = YES;//点击柱形图是否显示箭头
    self.barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
    
    //交互设置
    self.barChartView.scaleYEnabled = NO;//取消Y轴缩放
    self.barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    self.barChartView.dragEnabled = YES;//启用拖拽图表
    self.barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    self.barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
    //X轴样式
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.axisLineWidth = 1;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    xAxis.spaceBetweenLabels = 4;//设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
    xAxis.labelTextColor = [UIColor brownColor];//label文字颜色
    
    //右边Y轴样式
    self.barChartView.rightAxis.enabled = NO;//不绘制右边轴
    
    //左边Y轴样式
    ChartYAxis *leftAxis = self.barChartView.leftAxis;//获取左边Y轴
    leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    leftAxis.showOnlyMinMaxEnabled = NO;//是否只显示最大值和最小值
    leftAxis.axisMinValue = 35;//设置Y轴的最小值
    leftAxis.startAtZeroEnabled = NO;//从0开始绘制
    leftAxis.axisMaxValue = 40.5;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineWidth = 0.5;//Y轴线宽
    leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];//自定义格式
    leftAxis.valueFormatter.positiveSuffix = @" ℃";//数字后缀单位
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [UIColor brownColor];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    //网格线样式
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    //添加限制线
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:37.5 label:@"标准体温"];
    limitLine.lineWidth = 2;
    limitLine.lineColor = [UIColor greenColor];
    limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
    limitLine.labelPosition = ChartLimitLabelPositionRightTop;//位置
    [leftAxis addLimitLine:limitLine];//添加到Y轴上
    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在柱形图的后面
    
    //图例说明样式
    self.barChartView.legend.enabled = NO;//不显示图例说明
    //    self.barChartView.legend.position = ChartLegendPositionBelowChartLeft;//位置
    
    //右下角的description文字样式
    self.barChartView.descriptionText = @"";//不显示，就设为空字符串即可
    self.barChartView.descriptionText = @"体温图";
    
    self.data = [self setData];
    
    //为柱形图提供数据
    self.barChartView.data = self.data;
    
    //设置动画效果，可以设置X轴和Y轴的动画效果
    [self.barChartView animateWithYAxisDuration:1.0f];
    
    //改变数据button
//    UIButton *updateDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    updateDataBtn.frame = CGRectMake(20, 340, SCR_W-40, 40);
//    [updateDataBtn setTitle:@"改变数据" forState:UIControlStateNormal];
//    [updateDataBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [updateDataBtn setBackgroundColor:[UIColor cyanColor]];
//    updateDataBtn.layer.cornerRadius = 5;
//    [self.view addSubview:updateDataBtn];
//    [updateDataBtn addTarget:self action:@selector(updateDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//为柱形图设置数据
- (BarChartData *)setData{
    
    int xVals_count = 7;//X轴上要显示多少条数据
    double maxYVal = 40;//Y轴的最大值
    
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"第%d天", i+1]];
    }
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSMutableArray *yValss = [[NSMutableArray alloc] init];

    for (int i = 0; i < xVals_count; i++) {
        double mult = maxYVal + 1;
        double val = (double)(arc4random_uniform(mult-35)+35);
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithValue:val xIndex:i];
        [yVals addObject:entry];
        
        double multt = maxYVal + 1;
        double valt = (double)(arc4random_uniform(multt-35)+35);
        BarChartDataEntry *entry1 = [[BarChartDataEntry alloc] initWithValue:valt xIndex:i];
        [yValss addObject:entry1];
    }
    
    //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:nil];
    set1.barSpace = 0.2;//柱形之间的间隙占整个柱形(柱形+间隙)的比例
    set1.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set1.highlightEnabled = NO;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    [set1 setColors:ChartColorTemplates.material];//设置柱形图颜色
    
    
    //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithYVals:yValss label:nil];
    set2.barSpace = 0.2;//柱形之间的间隙占整个柱形(柱形+间隙)的比例
    set2.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set2.highlightEnabled = NO;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    [set2 setColors:ChartColorTemplates.material];//设置柱形图颜色
    
    
    //将BarChartDataSet对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];

    
    //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];//文字字体
    [data setValueTextColor:[UIColor orangeColor]];//文字颜色
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#0.0"];
    [data setValueFormatter:formatter];
    
    return data;
}

-(void)updateDataBtnClick{
    //数据改变时，刷新数据
    self.data = [self setData];
    self.barChartView.data = self.data;
    [self.barChartView notifyDataSetChanged];
}

#pragma mark - ChartViewDelegate

//点击选中柱形时回调
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * _Nonnull)highlight{
    //    NSLog(@"---chartValueSelected---value: %g", entry.value);
}
//没有选中柱形图时回调，当选中一个柱形图后，在空白处双击，就可以取消选择，此时会回调此方法
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    //    NSLog(@"---chartValueNothingSelected---");
}
//放大图表时回调
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    //    NSLog(@"---chartScaled---scaleX:%g, scaleY:%g", scaleX, scaleY);
}
//拖拽图表时回调
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    //    NSLog(@"---chartTranslated---dX:%g, dY:%g", dX, dY);
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
