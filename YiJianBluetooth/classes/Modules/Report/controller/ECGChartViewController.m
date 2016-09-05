//
//  ECGChartViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/10.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ECGChartViewController.h"
#import "Helper.h"
#import "PieChart.h"

#import "UsersDao.h"
#import "User.h"
#import "MasterDao.h"
#import "DropDownMenu.h"
#import "GetUserFamilyThred.h"
@interface ECGChartViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    PieChart *_pieChart1;
    PieChart *_pieChart2;
    PieChart *_pieChart3;
    PieChart *_pieChart4;
    
    Master *_master;
    mUser *_muser;
}

@property (nonatomic, strong) NSArray *user_classifys;
@property (nonatomic, strong) NSArray *user_cates;

@property (nonatomic, weak) DOPDropDownMenu *menu;

@end

@implementation ECGChartViewController

@synthesize leads, btnStart,scrollView, labelProfileId, labelProfileName, btnDismiss;
@synthesize liveMode, labelRate, statusInfo, startRecordingIndex, HR, stopTheTimer;
@synthesize buffer, DEMO, labelMsg, photoView, btnRefresh, newBornMode;

int leadCount = 2;
int sampleRate = 500;
float uVpb = 0.9;
float drawingInterval = 0.04; // the interval is greater, the drawing is faster, but more choppy, smaller -> slower and smoother
int bufferSecond = 300;
float pixelPerUV = 5 * 10.0 / 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addViews];
    [self initialMonitor];
    [self initLeftBarButtonItem];

    
    [self addTitleButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLeadsLayout:self.interfaceOrientation];
   
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startLiveMonitoring];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Initialization, Monitoring and Timer events

- (void)initialMonitor
{
    self.labelRate = [[UILabel alloc] initWithFrame:CGRectMake(260, 8, 49, 13)];
    self.labelRate.text = @"68";
    self.labelRate.textColor = [UIColor greenColor];
    [self.view addSubview:self.labelRate];
    
    bufferCount = 10;
    self.labelMsg = [[UILabel alloc] initWithFrame:CGRectMake(100, 8, 160, 13)];
    self.labelMsg.text = @"25mm/s  10mm/mv";
        self.labelMsg.textColor = [UIColor greenColor];
    [self.view addSubview:self.labelMsg];
    
    self.btnRecord.enabled = NO;
    self.btnDismiss.enabled = NO;
    
    NSMutableArray *buf = [[NSMutableArray alloc] init];
    self.buffer = buf;
}

- (void)startLiveMonitoring
{
    monitoring = YES;
    stopTheTimer = NO;
    
    [self startTimer_popDataFromBuffer];
    [self startTimer_drawing];
}

- (void)startTimer_popDataFromBuffer
{
    CGFloat popDataInterval = 420.0f / sampleRate;
    
    popDataTimer = [NSTimer scheduledTimerWithTimeInterval:popDataInterval
                                                    target:self
                                                  selector:@selector(timerEvent_popData)
                                                  userInfo:NULL
                                                   repeats:YES];
}

- (void)startTimer_drawing
{
    drawingTimer = [NSTimer scheduledTimerWithTimeInterval:drawingInterval
                                                    target:self
                                                  selector:@selector(timerEvent_drawing)
                                                  userInfo:NULL
                                                   repeats:YES];
}


- (void)timerEvent_drawing
{
    [self drawRealTime];
}

- (void)timerEvent_popData
{
    [self popDemoDataAndPushToLeads];
}

- (void)popDemoDataAndPushToLeads
{
    int length = 440;
    short **data = [Helper getDemoData:length];
    
    NSArray *data12Arrays = [self convertDemoData:data dataLength:length doWilsonConvert:NO];
    
    for (int i=0; i<leadCount; i++)
    {
        NSArray *data = [data12Arrays objectAtIndex:i];
        [self pushPoints:data data12Index:i];
    }
}

- (void)pushPoints:(NSArray *)_pointsArray data12Index:(NSInteger)data12Index;
{
    LeadPlayer *lead = [self.leads objectAtIndex:data12Index];
    
    if (lead.pointsArray.count > bufferSecond * sampleRate)
    {
        [lead resetBuffer];
    }
    
    if (lead.pointsArray.count - lead.currentPoint <= 2000)
    {
        [lead.pointsArray addObjectsFromArray:_pointsArray];
    }
    
    if (data12Index==0)
    {
        countOfPointsInQueue = lead.pointsArray.count;
        currentDrawingPoint = lead.currentPoint;
    }
}

- (NSArray *)convertDemoData:(short **)rawdata dataLength:(int)length doWilsonConvert:(BOOL)wilsonConvert
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i=0; i<12; i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [data addObject:array];
    }
    
    for (int i=0; i<length; i++)
    {
        for (int j=0; j<12; j++)
        {
            NSMutableArray *array = [data objectAtIndex:j];
            NSNumber *number = [NSNumber numberWithInt:rawdata[i][j]];
            [array insertObject:number atIndex:i];
        }
    }
    
    return data;
}

- (void)drawRealTime
{
    LeadPlayer *l = [self.leads objectAtIndex:0];
    
    if (l.pointsArray.count > l.currentPoint)
    {
        for (LeadPlayer *lead in self.leads)
        {
            [lead fireDrawing];
        }
    }
}

- (void)addViews
{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 36, SCR_W, SCR_H-36-NAVIGATION_HEIGHT); // frame中的size指UIScrollView的可视范围
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    // 隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
//    [_scrollView setContentSize:CGSizeMake(SCR_W, 730)];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0; i<leadCount; i++) {
        LeadPlayer *lead = [[LeadPlayer alloc] init];
        
        lead.layer.cornerRadius = 8;
        lead.layer.borderColor = [[UIColor grayColor] CGColor];
        lead.layer.borderWidth = 1;
        lead.clipsToBounds = YES;
        
        lead.index = i;
        lead.pointsArray = [[NSMutableArray alloc] init];
        
        lead.liveMonitor = self;
		      
        [array insertObject:lead atIndex:i];
        
        [self.scrollView addSubview:lead];
    }
    
    self.leads = array;
    
    
}

- (void)setLeadsLayout:(UIInterfaceOrientation)orientation
{
    float margin = 5;
    NSInteger leadHeight = self.scrollView.frame.size.height / 3 - margin * 2;
    NSInteger leadWidth = self.scrollView.frame.size.width-20;
    
    for (int i=0; i<leadCount; i++)
    {
        LeadPlayer *lead = [self.leads objectAtIndex:i];
        float pos_y = i * (margin + leadHeight);
        
        [lead setFrame:CGRectMake(10., pos_y, leadWidth, leadHeight)];
        lead.pos_x_offset = lead.currentPoint;
        lead.alpha = 0;
        [lead setNeedsDisplay];
    }
    
    [UIView animateWithDuration:0.6f animations:^{
        for (int i=0; i<leadCount; i++)
        {
            LeadPlayer *lead = [self.leads objectAtIndex:i];
            lead.alpha = 1;
        }
    }];
    
    _pieChart1 = [[PieChart alloc] initWithFrame:CGRectMake(20, self.leads.count*(leadHeight+5)+300*0, SCR_W-40, 300)];
    _pieChart2 = [[PieChart alloc] initWithFrame:CGRectMake(20, self.leads.count*(leadHeight+5)+300*1, SCR_W-40, 300)];
    _pieChart3 = [[PieChart alloc] initWithFrame:CGRectMake(20, self.leads.count*(leadHeight+5)+300*2, SCR_W-40, 300)];
    _pieChart4 = [[PieChart alloc] initWithFrame:CGRectMake(20, self.leads.count*(leadHeight+5)+300*3, SCR_W-40, 300)];
    
    [self.scrollView addSubview:_pieChart1];
    [self.scrollView addSubview:_pieChart2];
    [self.scrollView addSubview:_pieChart3];
    [self.scrollView addSubview:_pieChart4];
    
    //富文本
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"心电"];
    [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor orangeColor]} range:NSMakeRange(0, centerText.length)];
    _pieChart1.pieChartView.centerAttributedText = centerText;
    _pieChart2.pieChartView.centerAttributedText = centerText;
    _pieChart3.pieChartView.centerAttributedText = centerText;
    _pieChart4.pieChartView.centerAttributedText = centerText;

    _pieChart1.pieChartView.descriptionText=@"日-心电饼状图";
    _pieChart2.pieChartView.descriptionText=@"周-心电饼状图";
    _pieChart3.pieChartView.descriptionText=@"月-心电饼状图";
    _pieChart4.pieChartView.descriptionText=@"季度-心电饼状图";
    
    
    float bottom = 20.0;
    scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.leads.count*(leadHeight+5)+300*4+bottom);

    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}


#pragma mark -
#pragma mark Memory and others

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    
    drawingTimer = nil;
    readDataTimer = nil;
    popDataTimer = nil;
    
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
