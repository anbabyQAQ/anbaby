//
//  ReportViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ReportViewController.h"
#import "YiJianBluetooth-Bridging-Header.h"
#import "YiJianBluetooth-Swift.h"
#import "TempChartViewController.h"
#import "HeartRateViewController.h"
#import "ECGChartViewController.h"
#import "BloodSugarViewController.h"
#import "BloodPressureViewController.h"
#import "BloodOxygenViewController.h"
#import "GetUserFamilyThred.h"
#import "UsersDao.h"
#import "User.h"
#import "MasterDao.h"
#import "DropDownMenu.h"

@interface ReportViewController ()<ChartViewDelegate,ChartXAxisValueFormatter,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
       Master *_master;
        mUser *_muser;

}

@property (nonatomic, strong) RadarChartView *radarChartView;
@property (nonatomic, strong) RadarChartData *data;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;
@property (nonatomic, strong) UIButton *btn6;


@property (nonatomic, strong) NSArray *title_arr;


@property (nonatomic, strong) NSArray *user_classifys;
@property (nonatomic, strong) NSArray *user_cates;


@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, weak) DOPDropDownMenu *menu;


@end

@implementation ReportViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    self.tabBarController.tabBar.translucent=NO;
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_arr   = @[@"体温",@"心电",@"心率",@"血糖",@"血压",@"血氧"];

    // Do any additional setup after loading the view.
    self.navigationItem.title = @"报告";

    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建雷达图对象
    self.radarChartView = [[RadarChartView alloc] initWithFrame:CGRectMake(20, 10, SCR_W-40, 300)];
    [self.view addSubview:self.radarChartView];
    self.radarChartView.delegate = self;
    self.radarChartView.descriptionText = @"各项雷达图";//描述
    self.radarChartView.rotationEnabled = YES;//是否允许转动
    self.radarChartView.highlightPerTapEnabled = YES;//是否能被选中
    
    
    
    
    //雷达图线条样式
    self.radarChartView.webLineWidth = 0.5;//主干线线宽
    self.radarChartView.webColor = [self colorWithHexString:@"#c2ccd0"];//主干线线宽
    self.radarChartView.innerWebLineWidth = 0.375;//边线宽度
    self.radarChartView.innerWebColor = [self colorWithHexString:@"#c2ccd0"];//边线颜色
    self.radarChartView.webAlpha = 1;//透明度
    self.radarChartView.drawWeb = YES;
    
    //设置 xAxi
    ChartXAxis *xAxis = self.radarChartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:15];//字体
//    xAxis.labelTextColor = [self colorWithHexString:@"#057748"];//颜色
    xAxis.labelTextColor = normolColor;//颜色

    xAxis.enabled=YES;
    xAxis.valueFormatter=self;
    
    
    
    //设置 yAxis
    ChartYAxis *yAxis = self.radarChartView.yAxis;
    yAxis.axisMinValue = 0.0;//最小值
    yAxis.axisMaxValue = 150.0;//最大值
    yAxis.drawLabelsEnabled = NO;//是否显示 label
    yAxis.labelCount = 6;// label 个数
    yAxis.labelFont = [UIFont systemFontOfSize:9];// label 字体
    yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
    
    
    //为雷达图提供数据
    self.data = [self setData];
    self.radarChartView.data = self.data;
    [self.radarChartView renderer];
    
    //设置动画
    [self.radarChartView animateWithYAxisDuration:0.1f];
    
    //改变数据button
//    UIButton *updateDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    updateDataBtn.frame = CGRectMake(20, 330, SCR_W-40, 40);
//    [updateDataBtn setTitle:@"改变数据" forState:UIControlStateNormal];
//    [updateDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [updateDataBtn setBackgroundColor:normolColor];
//    updateDataBtn.layer.cornerRadius = 5;
//    [self.view addSubview:updateDataBtn];
//    [updateDataBtn addTarget:self action:@selector(updateDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 setBackgroundColor:[UIColor clearColor]];
//    _btn1.layer.cornerRadius = 5;
    _btn1.tag = 100;
    _btn1.alpha=0.05;

    [_btn1 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn2 setBackgroundColor:[UIColor clearColor]];
//    _btn2.layer.cornerRadius = 5;
    _btn2.tag = 101;
    _btn2.alpha=0.05;

    [_btn2 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn3 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn3 setBackgroundColor:[UIColor clearColor]];
//    _btn3.layer.cornerRadius = 5;
    _btn3 .tag = 102;
    _btn3.alpha=0.05;

    [_btn3 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn4 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn4 setBackgroundColor:[UIColor clearColor]];
//    _btn4.layer.cornerRadius = 5;
    _btn4.tag = 103;
    _btn4.alpha=0.05;

    [_btn4 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn5 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn5 setBackgroundColor:[UIColor clearColor]];
//    _btn5.layer.cornerRadius = 5;
    _btn5.tag = 104;
    _btn5.alpha=0.05;

    [_btn5 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn6 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn6 setBackgroundColor:[UIColor clearColor]];
//    _btn6.layer.cornerRadius = 5;
    _btn6.alpha=0.05;
    _btn6.tag = 105;
    [_btn6 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.radarChartView addSubview:self.btn1];
    [self.radarChartView addSubview:self.btn2];
    [self.radarChartView addSubview:self.btn3];
    [self.radarChartView addSubview:self.btn4];
    [self.radarChartView addSubview:self.btn5];
    [self.radarChartView addSubview:self.btn6];
    
    [self addTitleButton];
   
}

#pragma mark 导航栏中间title按钮
-(void)addTitleButton{
    self.user_classifys = @[@"我的家人",@"田玉龙",@"孙成雷",@"安小平",@"田玉龙",@"孙成雷",@"安小平"];
    self.user_cates = @[@"田玉龙",@"孙成雷",@"安小平",@"田玉龙"];
  
    
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



- (void)pushBtn:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 100://体温
        {
            TempChartViewController *Temp = [[TempChartViewController alloc] init];
            Temp.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:Temp animated:YES];
        }
            break;
        case 101:
        {
            
            ECGChartViewController *ECG = [[ECGChartViewController alloc] init];
            ECG.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ECG animated:YES];
        }
            break;
        case 102:
        {
            HeartRateViewController *HeartRate = [[HeartRateViewController alloc] init];
            HeartRate.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:HeartRate animated:YES];
        }
            break;
        case 103:
        {
            
            BloodSugarViewController *BloodSugar = [[BloodSugarViewController alloc] init];
            BloodSugar.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:BloodSugar animated:YES];
        }
            break;
        case 104:
        {
            
            BloodPressureViewController *BloodPressure = [[BloodPressureViewController alloc] init];
            
            BloodPressure.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:BloodPressure animated:YES];
        }
            break;
        case 105:
        {
            
            BloodOxygenViewController *BloodOxygen = [[BloodOxygenViewController alloc] init];
            BloodOxygen.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:BloodOxygen animated:YES];
        }
            break;
  
            
        default:
            break;
    }
    
}

//刷新数据
- (void)updateDataBtnClick{
    self.data = [self setData];
    self.radarChartView.data = self.data;
    [self.radarChartView animateWithYAxisDuration:0.1f];
}

//创建数据
- (RadarChartData *)setData{
    
    double mult = 100;
    int count = 6;//维度的个数
    
    //每个维度的名称或描述
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"%@", self.title_arr[i]]];
    }
    
    //每个维度的数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult) + mult / 2;//产生 50~150 的随机数
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
        [yVals1 addObject:entry];
    }
    
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithYVals:yVals1 label:@"标准"];
    set1.lineWidth = 0.5;//数据折线线宽
//    [set1 setColor:[self colorWithHexString:@"#ff8936"]];//数据折线颜色
    set1.drawFilledEnabled = YES;//是否填充颜色
//    set1.fillColor = [self colorWithHexString:@"#ff8936"];//填充颜色
    [set1 setColor:[self colorWithHexString:@"#ff2d51"]];
    set1.fillColor = [self colorWithHexString:@"#ff2d51"];
    set1.fillAlpha = 0.25;//填充透明度
    set1.drawValuesEnabled = NO;//是否绘制显示数据
    set1.valueFont = [UIFont systemFontOfSize:9];//字体
    set1.valueTextColor = [UIColor grayColor];//颜色
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult) + mult / 2;//产生 50~150 的随机数
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
        [yVals2 addObject:entry];
    }
    RadarChartDataSet *set2 = [[RadarChartDataSet alloc] initWithYVals:yVals2 label:@"测量(高压)"];
    set2.lineWidth = 0.5;//数据折线线宽
    set2.drawFilledEnabled = YES;//是否填充颜色
    [set2 setColor:[UIColor greenColor]];
    set2.fillColor = [UIColor greenColor];
    set2.fillAlpha = 0.25;//填充透明度
    set2.drawValuesEnabled = NO;//是否绘制显示数据
    set2.valueFont = [UIFont systemFontOfSize:9];//字体
    set2.valueTextColor = [UIColor grayColor];//颜色
    
    
    //高压低压 type  处理
    
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        if (i==4) {
            
            double randomVal = arc4random_uniform(mult) + mult / 2;//产生 50~150 的随机数
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
            [yVals3 addObject:entry];
        }else{
            if (i==3 || i==5) {
                double randomVal = 100;//产生 50~150 的随机数
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
                [yVals3 addObject:entry];
            }else{
                
                double randomVal = 0;//产生 50~150 的随机数
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
                [yVals3 addObject:entry];
            }
            
        }
    }
    RadarChartDataSet *set3 = [[RadarChartDataSet alloc] initWithYVals:yVals3 label:@"(低压)"];
    set3.lineWidth = 0.5;//数据折线线宽
    set3.drawFilledEnabled = YES;//是否填充颜色
    [set3 setColor:[UIColor orangeColor]];
    set3.fillColor = [UIColor orangeColor];
    set3.fillAlpha = 0.25;//填充透明度
    set3.drawValuesEnabled = NO;//是否绘制显示数据
    set3.valueFont = [UIFont systemFontOfSize:9];//字体
    set3.valueTextColor = [UIColor grayColor];//颜色
    
    RadarChartData *data = [[RadarChartData alloc] initWithXVals:xVals dataSets:@[set1,set2,set3]];
    
    return data;
}
-(NSString *)stringForXValue:(NSInteger)index original:(NSString *)original viewPortHandler:(ChartViewPortHandler *)viewPortHandler x:(CGFloat)x y:(CGFloat)y{
    
    switch (index) {
        case 0:
        {
            _btn1.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 1:
        {
            _btn2.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 2:
        {
            _btn3.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 3:
        {
            _btn4.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 4:
        {
            _btn5.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 5:
        {
            _btn6.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
 
            
        default:
            break;
    }
    
    
    return original;
}

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * _Nonnull)highlight{
    
    
    //    NSLog(@"chartValueSelected");
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    //    NSLog(@"chartValueNothingSelected");
    //    NSLog(@"%@",chartView._data);
    
    
}
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    //    NSLog(@"chartScaled");
    
}
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    //    NSLog(@"chartTranslated");
}

#pragma mark --- 将十六进制颜色转换为 UIColor 对象
- (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
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
//        [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
    }
    
    
    [_master.users enumerateObjectsUsingBlock:^(mUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        mUser *m = (mUser*)obj;
        if ([m.name isEqualToString:_master.showName]) {
            _muser = m;
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
