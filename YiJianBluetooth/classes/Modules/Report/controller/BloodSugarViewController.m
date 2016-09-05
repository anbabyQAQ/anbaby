
//
//  BloodSugarViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BloodSugarViewController.h"
#import "BrokenLine.h"
#import "PieChart.h"
#import "UsersDao.h"
#import "User.h"
#import "MasterDao.h"
#import "DropDownMenu.h"
#import "GetUserFamilyThred.h"
@interface BloodSugarViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    BrokenLine *_barChartView1;
    BrokenLine *_barChartView2;
    
    
    
    PieChart *_pieChart1;
    PieChart *_pieChart2;
    PieChart *_pieChart3;
    PieChart *_pieChart4;
    
    Master *_master;
    mUser *_muser;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *user_classifys;
@property (nonatomic, strong) NSArray *user_cates;

@property (nonatomic, weak) DOPDropDownMenu *menu;
@end

@implementation BloodSugarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addScrollview];
    [self initLeftBarButtonItem];

   
    [self addTitleButton];
    self.view.backgroundColor = [UIColor whiteColor];
}
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

- (void)addScrollview{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, SCR_W, SCR_H); // frame中的size指UIScrollView的可视范围
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    // 隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    
    _barChartView1 = [[BrokenLine alloc] initWithFrame:CGRectMake(20, 10, SCR_W-40, 200) type:NO];
    _barChartView2 = [[BrokenLine alloc] initWithFrame:CGRectMake(20, 230, SCR_W-40, 200) type:NO];
    
    _barChartView1.LineChartView.descriptionText=@"饭前血糖图";
    _barChartView2.LineChartView.descriptionText=@"饭后血糖图";
    
    [self.scrollView addSubview:_barChartView1];
    [self.scrollView addSubview:_barChartView2];
    
    
    _pieChart1 = [[PieChart alloc] initWithFrame:CGRectMake(20, 440+300*0, SCR_W-40, 300)];
    _pieChart2 = [[PieChart alloc] initWithFrame:CGRectMake(20, 440+300*1, SCR_W-40, 300)];
    _pieChart3 = [[PieChart alloc] initWithFrame:CGRectMake(20, 440+300*2, SCR_W-40, 300)];
    _pieChart4 = [[PieChart alloc] initWithFrame:CGRectMake(20, 440+300*3, SCR_W-40, 300)];
    
    [self.scrollView addSubview:_pieChart1];
    [self.scrollView addSubview:_pieChart2];
    [self.scrollView addSubview:_pieChart3];
    [self.scrollView addSubview:_pieChart4];
    
    //富文本
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"血糖"];
    [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor orangeColor]} range:NSMakeRange(0, centerText.length)];
    _pieChart1.pieChartView.centerAttributedText = centerText;
    _pieChart2.pieChartView.centerAttributedText = centerText;
    _pieChart3.pieChartView.centerAttributedText = centerText;
    _pieChart4.pieChartView.centerAttributedText = centerText;
    
    _pieChart1.pieChartView.descriptionText=@"空腹-日-血糖饼状图";
    _pieChart2.pieChartView.descriptionText=@"空腹-周-血糖饼状图";
    _pieChart3.pieChartView.descriptionText=@"空腹-月-血糖饼状图";
    _pieChart4.pieChartView.descriptionText=@"空腹-季度-血糖饼状图";
    
    
    float bottom = 20.0;
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 440+300*4+bottom+NAVIGATION_HEIGHT);
    
    
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
//        [MasterDao updateMaster:_master Byaid:[NSNumber numberWithInteger:_master.aid]];
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
