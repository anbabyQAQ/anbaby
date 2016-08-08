//
//  TempViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/8.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TempViewController.h"
#import "MAThermometer.h"

@interface TempViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}
@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;
@property (nonatomic, strong) UIView   *temp_view;

@property (nonatomic, strong) UITableView *tempTableview;

@property (nonatomic, strong) MAThermometer * thermometer1;


//设备数组
@property (nonatomic, strong) NSMutableArray *peripheral_arr;

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"温度";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTempLayout];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];

    MyCustomButton *mapbutton = [MyCustomButton buttonWithType:UIButtonTypeSystem];
    [mapbutton setFrame:CGRectMake(0, 0, 40 , 30)];
    [mapbutton setBackgroundColor:[UIColor purpleColor]];
    [mapbutton addTarget:self action:@selector(setRightBtn) forControlEvents:UIControlEventTouchDown];
    [view addSubview:mapbutton];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self addtableview];
    
}

- (void)addtableview{
    _peripheral_arr = [[NSMutableArray alloc] initWithObjects:@"1111",@"2222", nil];

    _tempTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _peripheral_arr.count*40)];
    _tempTableview.delegate=self;
    _tempTableview.dataSource=self;
    [_tempTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setExtraCellLineHidden:_tempTableview];
    _tempTableview.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:_tempTableview];
    
    _tempTableview.hidden= YES;
    
}

-(void)setRightBtn{
    
    _tempTableview.hidden = !_tempTableview.hidden;
    
}

- (void) initTempLayout{
    self.temp_lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    self.temp_lab.textAlignment=NSTextAlignmentLeft;
    self.temp_lab.text=@"体温";
    self.temp_lab.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.temp_lab.textColor = [UIColor grayColor];
    [self.view addSubview: self.temp_lab];
    
    
    _temp_view = [[UIView alloc] initWithFrame:CGRectMake(110, 50, 100, 200)];
    _temp_view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.temp_view.layer.masksToBounds = YES;
    self.temp_view.layer.cornerRadius = 6.0;
    self.temp_view.layer.borderWidth = 1.0;
    self.temp_view.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_temp_view];

    
    _thermometer1 = [[MAThermometer alloc] initWithFrame:_temp_view.bounds];
    [_thermometer1 setMaxValue:42];
    [_thermometer1 setMinValue:35];
    _thermometer1.glassEffect = YES;
    int x = arc4random() % 8+35;
    int y = arc4random()%10;
    _thermometer1.curValue = x+y*0.1;
    [_temp_view addSubview:_thermometer1];
    
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(220, 70, 80, 20)];
    temp.textAlignment=NSTextAlignmentLeft;
    temp.text=[NSString stringWithFormat:@"%.2f℃",x+y*0.1];
    temp.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    temp.textColor = [UIColor grayColor];
    [self.view addSubview: temp];
    
    
    _startTest_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startTest_btn.frame = CGRectMake(20, SCR_H-NAVIGATION_HEIGHT-70, SCR_W-40, 50);
    [_startTest_btn addTarget:self action:@selector(clickbtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _startTest_btn.backgroundColor = [UIColor blueColor];
    [_startTest_btn setTitle:@"开始测体温" forState:(UIControlStateNormal)];
    self.startTest_btn.layer.masksToBounds = YES;
    self.startTest_btn.layer.cornerRadius = 6.0;
    self.startTest_btn.layer.borderWidth = 1.0;
    self.startTest_btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_startTest_btn];
    
}

- (void)clickbtn:(id)sender{
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheral_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    static NSString *NailCellIdentifier = @"NailCell";
    UITableViewCell *nailcell = [tableView dequeueReusableCellWithIdentifier:NailCellIdentifier];
    if (nailcell == nil) {
        nailcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NailCellIdentifier];
    }
    nailcell.textLabel.textAlignment = NSTextAlignmentLeft;
    nailcell.textLabel.text = _peripheral_arr[indexPath.row];
    [nailcell.textLabel setFont:[UIFont systemFontOfSize:text_size_small]];
    nailcell.imageView.image = nil;
    nailcell.accessoryType = UITableViewCellAccessoryNone;
    nailcell.backgroundColor = [UIColor whiteColor];
    nailcell.alpha=1;
    return nailcell;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
   
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
