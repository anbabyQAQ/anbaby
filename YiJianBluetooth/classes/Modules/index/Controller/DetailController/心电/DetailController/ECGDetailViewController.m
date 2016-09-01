//
//  ECGDetailViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ECGDetailViewController.h"
#import "ChooseUser.h"
#import "User.h"
#import "UsersDao.h"
#import "Helper.h"
#import "PersonalInfoViewController.h"
@interface ECGDetailViewController ()<UIScrollViewDelegate,chooseUserDelegate>{
    NSInteger _type;
    User *_user;
}

@property(nonatomic, strong)UIScrollView *scrollerView;


@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;

@property (nonatomic, strong) UILabel *electricityLabel;//电量

@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, strong) UIImageView *pictureImageView;


@property (nonatomic, strong) UILabel *HRLabel;
@property (nonatomic, strong) UILabel *RRMAXLabel;
@property (nonatomic, strong) UILabel *RRMINLabel;
@property (nonatomic, strong) UILabel *HRVLabel;
@property (nonatomic, strong) UILabel *MoodLabel;

@property (nonatomic, strong) NSMutableArray *ECGdata;


@end

@implementation ECGDetailViewController

@synthesize leads, btnStart, labelProfileId, labelProfileName, btnDismiss;
@synthesize liveMode, labelRate, statusInfo, startRecordingIndex, HR, stopTheTimer;
@synthesize buffer, DEMO, labelMsg, photoView, btnRefresh, newBornMode;

int leadCountDetail = 1;
int sampleRateDetail = 500;
float uVpb = 0.9;
float drawingIntervalDetail = 0.04; // the interval is greater, the drawing is faster, but more choppy, smaller -> slower and smoother
int bufferSecondDetail = 300;
float pixelPerUV = 5 * 10.0 / 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, SCR_H-NAVIGATION_HEIGHT-80)];
    self.scrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollerView];
    
    [self addChartViews];
    
    [self initTempLayout];
    [self initLeftBarButtonItem];
    [self initrightBarButtonItem:@"重新测量" action:@selector(measureTemp)];


}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self initwithScroll];
    [self setLeadsLayout:self.interfaceOrientation];

}

- (void)measureTemp{
    if (_type==2) {
        [_linktopManager startECG];
        
    }
}

- (void)backToSuper{
    [_linktopManager endECG];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initwithScroll{
    
    _users = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
    
    ChooseUser *view = [[ChooseUser alloc]initWithFrame:CGRectMake(0, self.MoodLabel.frame.origin.y + 40, SCR_W, 80)];
    view.user_delegate =self;
    [view setWithUserInfo:_users];
    [self.scrollerView addSubview:view];
    
}

-(void)initTempLayout{
    self.temp_lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 20)];
    [self addUILabel:self.temp_lab labelString:@"心电"];
    
//    self.electricityLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCR_W - 165, 20, 150, 20)];
//    self.electricityLabel.textAlignment=NSTextAlignmentCenter;
//    self.electricityLabel.text=@"仪器用电量";
//    self.electricityLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
//    self.electricityLabel.textColor = [UIColor blackColor];
//    [self.scrollerView addSubview: self.electricityLabel];
    
    
    self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, SCR_W - 40, SCR_H/667 *150)];
//    self.pictureImageView.image = [UIImage imageNamed:@"Yosemite04.jpg"];
    [self.scrollerView addSubview:self.pictureImageView];
    
    
    self.HRLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.pictureImageView.frame.origin.y + self.pictureImageView.frame.size.height + 20, 150, 20)];
    [self addUILabel:self.HRLabel labelString:@"HR:"];
   
    self.RRMAXLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.HRLabel.frame.origin.y + 40, 150, 20)];
    [self addUILabel:self.RRMAXLabel labelString:@"RRMAX:"];
    
     self.RRMINLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.RRMAXLabel.frame.origin.y + 40, 150, 20)];
    [self addUILabel:self.RRMINLabel labelString:@"RRMIN:"];
    
     self.HRVLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.RRMINLabel.frame.origin.y + 40, 150, 20)];
    [self addUILabel:self.HRVLabel labelString:@"HRV:"];
    
     self.MoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.HRVLabel.frame.origin.y + 40, 150, 20)];
    [self addUILabel:self.MoodLabel labelString:@"Mood:"];
    

    _startTest_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startTest_btn.frame = CGRectMake(20, SCR_H-NAVIGATION_HEIGHT-70, SCR_W-40, 50);
    [_startTest_btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _startTest_btn.backgroundColor = UIColorFromRGB(0xc62828);
    [_startTest_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_startTest_btn setTitle:@"保存记录" forState:(UIControlStateNormal)];
    self.startTest_btn.layer.masksToBounds = YES;
    self.startTest_btn.layer.cornerRadius = 6.0;
    self.startTest_btn.layer.borderWidth = 1.0;
    self.startTest_btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_startTest_btn];
    
    
    [self.scrollerView setContentSize:CGSizeMake(SCR_W, self.MoodLabel.frame.origin.y + 120)];
}

-(void)addUILabel:(UILabel *)label labelString:(NSString *)string{
    
    label.textAlignment=NSTextAlignmentLeft;
    label.text=string;
    label.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    label.textColor = [UIColor blackColor];
    [self.scrollerView addSubview: label];
}

- (void)setScantype:(NSInteger)scantype{
    _type = scantype;
    if (scantype==2) {
        _linktopManager.sdkHealthMoniterdelegate = self;
        [_linktopManager startECG];
        
    }
}


-(void)clickBtn:(id)sender{
    //缓存
    
    //    [_user.dicTemp  obj]
    if (_user) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_users.count>0) {
            [self showToast:@"请选择测量人"];
        }else{
            [self showToast:@"请添加测量人"];
        }
    }
    
    
}
#pragma mark ChooseUser代理

- (void)callBaceAddUser{
//    PersonalInformationViewController *pserson  = [[PersonalInformationViewController alloc] init];
//    [self.navigationController pushViewController:pserson animated:YES];
    
    PersonalInfoViewController *info = [[PersonalInfoViewController alloc] initWithUser:nil WithMaster:nil andEditable:YES];
    [self.navigationController pushViewController:info animated:YES];
}

-(void)callBackUser:(User *)user{
    //选取用户添加记录
    _user = user;
    
}
- (NSMutableArray *)users {
    if (_users == nil) {
        _users = [[NSMutableArray alloc]init];
    }
    return _users;
}

- (NSMutableArray *)ECGdata{
    if (_ECGdata == nil) {
        _ECGdata = [[NSMutableArray alloc] init];
    }
    return _ECGdata;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveECGDataRRmax:(int)rrMax
{
   self.RRMAXLabel.text =  [NSString stringWithFormat:@"rrMax:%d",rrMax];
    
}

-(void)receiveECGDataRRMin:(int)rrMin
{
   self.RRMINLabel.text =  [NSString stringWithFormat:@"rrMin:%d",rrMin];
    
}

-(void)receiveECGDataHRV:(int)hrv
{
  self.HRVLabel.text = [NSString stringWithFormat:@"HRV:%d",hrv];

    
}

-(void)receiveECGDataMood:(int)mood
{
    self.MoodLabel.text =  [NSString stringWithFormat:@"mood:%d",mood];
    
}

-(void)receiveECGDataSmoothedWave:(int)smoothedWave
{
    //心电图数据
    NSLog(@"ECG LineView Data:%d",smoothedWave);
    NSNumber *num = [NSNumber numberWithInt:smoothedWave];
    [self.ECGdata addObject:num];
    
}

-(void)receiveECGDataHeartRate:(int)heartRate
{
   self.HRLabel.text = [NSString stringWithFormat:@"heartRate:%d",heartRate];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startLiveMonitoring];
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
    CGFloat popDataInterval = 420.0f / sampleRateDetail;
    
    popDataTimer = [NSTimer scheduledTimerWithTimeInterval:popDataInterval
                                                    target:self
                                                  selector:@selector(timerEvent_popData)
                                                  userInfo:NULL
                                                   repeats:YES];
}

- (void)startTimer_drawing
{
    drawingTimer = [NSTimer scheduledTimerWithTimeInterval:drawingIntervalDetail
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
//    short **data = [Helper getDemoData:length];
    
    NSArray *data12Arrays = [self convertDemoData:self.ECGdata dataLength:length doWilsonConvert:NO];
    
//    for (int i=0; i<leadCountDetail; i++)
//    {
//        NSArray *data = [data12Arrays objectAtIndex:i];
        [self pushPoints:data12Arrays data12Index:0];
//    }
    
}

- (void)pushPoints:(NSArray *)_pointsArray data12Index:(NSInteger)data12Index;
{
    LeadPlayer *lead = [self.leads objectAtIndex:data12Index];
    
    if (lead.pointsArray.count > bufferSecondDetail * sampleRateDetail)
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

- (NSArray *)convertDemoData:(NSMutableArray*)rawdata dataLength:(int)length doWilsonConvert:(BOOL)wilsonConvert
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
//    for (int i=0; i<12; i++)
//    {
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        [data addObject:array];
//    }
    
    for (int i=0; i<length; i++)
    {
//        for (int j=0; j<12; j++)
//        {
//            NSMutableArray *array = [data objectAtIndex:j];
            if (rawdata.count>i ) {
//                NSNumber *number = [NSNumber numberWithInt:rawdata[i]];
                [data insertObject:rawdata[i] atIndex:i];

            }
//        }
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
- (void)addChartViews
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0; i<leadCountDetail; i++) {
        LeadPlayer *leadDetail = [[LeadPlayer alloc] init];
        
        leadDetail.layer.cornerRadius = 8;
        leadDetail.layer.borderColor = [[UIColor grayColor] CGColor];
        leadDetail.layer.borderWidth = 1;
        leadDetail.clipsToBounds = YES;
        
        leadDetail.index = i;
        leadDetail.pointsArray = [[NSMutableArray alloc] init];
        
        leadDetail.liveMonitorDetail = self;
		      
        [array insertObject:leadDetail atIndex:i];
        
        [self.scrollerView addSubview:leadDetail];
    }
    
    self.leads = array;
    
    
}

- (void)setLeadsLayout:(UIInterfaceOrientation)orientation
{
    float margin = 5;
    NSInteger leadHeight = SCR_H/667 *150;
    NSInteger leadWidth = self.scrollerView.frame.size.width-20;
    
    for (int i=0; i<leadCountDetail; i++)
    {
        LeadPlayer *lead = [self.leads objectAtIndex:i];
        float pos_y = i * (margin + leadHeight)+60;
        
        
        [lead setFrame:CGRectMake(10., pos_y, leadWidth, leadHeight)];
        lead.pos_x_offset = lead.currentPoint;
        lead.alpha = 0;
        [lead setNeedsDisplay];
    }
    
    [UIView animateWithDuration:0.6f animations:^{
        for (int i=0; i<leadCountDetail; i++)
        {
            LeadPlayer *lead = [self.leads objectAtIndex:i];
            lead.alpha = 1;
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
