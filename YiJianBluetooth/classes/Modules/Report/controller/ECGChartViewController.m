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
@interface ECGChartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    PieChart *_pieChart1;
    PieChart *_pieChart2;
    PieChart *_pieChart3;
    PieChart *_pieChart4;
}

@property(nonatomic, strong)UIButton *titleButton;
@property(nonatomic, strong)UITableView *dropDownTableView;
@property(nonatomic, strong)NSMutableArray *dropDownArray;

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

    //添加tableView
    [self addTablView];
    [self addTitleButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLeadsLayout:self.interfaceOrientation];
    self.dropDownArray = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
