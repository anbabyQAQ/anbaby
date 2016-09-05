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

#import "UsersDao.h"
#import "User.h"
#import "MasterDao.h"
#import "DropDownMenu.h"
#import "GetUserFamilyThred.h"
@interface TempChartViewController ()<ChartViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{

    Master *_master;
    mUser *_muser;
}
@property (nonatomic, strong) BarChartView *barChartView;
@property (nonatomic, strong) BarChartData *data;

@property (nonatomic, strong) NSArray *user_classifys;
@property (nonatomic, strong) NSArray *user_cates;

@property (nonatomic, weak) DOPDropDownMenu *menu;
@end

@implementation TempChartViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
     _master = [MasterDao getMasterByAid:[[NSUserDefaults standardUserDefaults] objectForKey:@"master_aid"]];
    if (_master) {
        if (_master.users.count>0) {
            _muser = [_master.users firstObject];
            NSMutableArray *user_arr = [[NSMutableArray alloc]init];
            for (mUser *m in _master.users) {
                [user_arr addObject:m.name];
            }
            self.user_classifys = [NSArray arrayWithArray:user_arr];
            [self menuReloadData];
            
            
            [_master.users enumerateObjectsUsingBlock:^(mUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                mUser *m = (mUser*)obj;
                if ([m.name isEqualToString:_master.showName]) {
                    [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:idx]];
                    _muser=m;
                }
            }];
            
        }else{
            [self getData];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initLeftBarButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addchartView];
    //添加tableView
    
    [self addTitleButton];
}
-(void)addchartView{

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



#pragma mark ===========导航栏中间title按钮
-(void)addTitleButton{
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44 andSuperView:self.view];
    menu.delegate = self;
    menu.dataSource = self;
    
    _menu = menu;
    
    self.navigationItem.titleView = _menu;
    
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    [menu selectDefalutIndexPath];
}
- (void)menuReloadData
{
    [_menu reloadData];
}

#pragma mark 下拉抽屉代理实现


- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.user_classifys.count;
    }else {
        return 0;
    }
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.user_classifys[indexPath.row];
    }  else {
        return 0;
    }
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 || indexPath.column == 1) {
        return [NSString stringWithFormat:@"我的－头像"];
    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return [NSString stringWithFormat:@"我的－头像"];
    }
    return nil;
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return  nil;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    //        if (column == 0) {
    //            if (row == 0) {
    //               return self.user_cates.count;
    //            }
    //        }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            return self.user_cates[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
    
    if (_user_classifys.count>indexPath.row) {
        NSString *name = [_user_classifys objectAtIndex:indexPath.row];
        _master.showName = name;
        [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
    }
    
    
    [_master.users enumerateObjectsUsingBlock:^(mUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        mUser *m = (mUser*)obj;
        if ([m.name isEqualToString:_master.showName]) {
            _muser = m;
        }
    }];
}


#pragma mark ========我的亲友列表请求
-(void)getData{
    
    
    NSString *aid = [NSString stringWithFormat:@"%ld", (long)_master.aid];
    GetUserFamilyThred *family = [[GetUserFamilyThred alloc] initWithAid:aid withToken:_master.token];
    [family requireonPrev:^{
        [self showHud:@"请求中..." onView:self.view];
    } success:^(NSMutableArray *response) {
        NSLog(@"%@", response);
        [self hideHud];
        
        if (response.count>0) {
            NSMutableArray *muser_arr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in response) {
                mUser *muser = [[mUser alloc] initWith:dic];
                [muser_arr addObject:muser];
            }
            _master.users = muser_arr;
            
            _muser = [_master.users firstObject];
            [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
            
            //抽屉刷新
            NSMutableArray *user_arr = [[NSMutableArray alloc]init];
            for (mUser *m in _master.users) {
                [user_arr addObject:m.name];
            }
            self.user_classifys = [NSArray arrayWithArray:user_arr];
            [self menuReloadData];
            
            [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0]];
            
            
        }else{
            [_master.users removeAllObjects];
            _muser = nil;
            [self showToast:@"请添加个人信息~"];
            
            [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
            
        }
        
    } unavaliableNetwork:^{
        [self hideHud];
        [self showToast:@"网络未连接"];
    } timeout:^{
        [self hideHud];
        [self showToast:@"网络连接超时"];
    } exception:^(NSString *message) {
        [self hideHud];
        if (message) {
            [self showToast:message];
        }else{
            [self showToast:@"位置错误"];
        }
    }];
    
    
    
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
