//
//  ECGViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ECGViewController.h"
#import "ECGDetailViewController.h"

@interface ECGViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    
}

@property (nonatomic, strong) UIButton *startTest_btn;
@property (nonatomic, strong) UIView   *temp_view;

@property (nonatomic, strong) UITableView *ECGTableview;


//设备数组
@property (nonatomic, strong) NSMutableArray *peripheral_arr;


@end

@implementation ECGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"心电";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTempLayout];
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    //    MyCustomButton *mapbutton = [MyCustomButton buttonWithType:UIButtonTypeSystem];
    //    [mapbutton setFrame:CGRectMake(0, 0, 60 , 30)];
    //    [mapbutton setTitle:@"连接设备" forState:(UIControlStateNormal)];
    //    [mapbutton setTintColor:[UIColor blueColor]];
    //    [mapbutton addTarget:self action:@selector(setRightBtn) forControlEvents:UIControlEventTouchDown];
    //    [view addSubview:mapbutton];
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:view];
    //    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"连接设备" style:UIBarButtonItemStyleDone target:self action:@selector(setRightBtn)] ;
    
    [self addtableview];
    
}

- (void)addtableview{
    _peripheral_arr = [[NSMutableArray alloc] initWithObjects:@"1111",@"2222", nil];
    
    _ECGTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _peripheral_arr.count*40)];
    _ECGTableview.delegate=self;
    _ECGTableview.dataSource=self;
    [_ECGTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setExtraCellLineHidden:_ECGTableview];
    _ECGTableview.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:_ECGTableview];
    
    _ECGTableview.hidden= YES;
    
}

-(void)setRightBtn{
    
    _ECGTableview.hidden = !_ECGTableview.hidden;
    
}

- (void) initTempLayout{
    
    _temp_view = [[UIView alloc] initWithFrame:CGRectMake(110, 50, 100, 150)];
    _temp_view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.temp_view.layer.masksToBounds = YES;
    self.temp_view.layer.cornerRadius = 6.0;
    self.temp_view.layer.borderWidth = 1.0;
    self.temp_view.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_temp_view];
    
    
//    _thermometer1 = [[MAThermometer alloc] initWithFrame:_temp_view.bounds];
//    [_thermometer1 setMaxValue:42];
//    [_thermometer1 setMinValue:35];
//    _thermometer1.glassEffect = YES;
//    int x = arc4random() % 8+35;
//    int y = arc4random()%10;
//    _thermometer1.curValue = x+y*0.1;
//    [_temp_view addSubview:_thermometer1];
//    

    
    
    _startTest_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startTest_btn.frame = CGRectMake(20, SCR_H-NAVIGATION_HEIGHT-70, SCR_W-40, 50);
    [_startTest_btn addTarget:self action:@selector(clickbtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _startTest_btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_startTest_btn setTitle:@"开始测体温" forState:(UIControlStateNormal)];
    [_startTest_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.startTest_btn.layer.masksToBounds = YES;
    self.startTest_btn.layer.cornerRadius = 6.0;
    self.startTest_btn.layer.borderWidth = 1.0;
    self.startTest_btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_startTest_btn];
    
}

- (void)clickbtn:(id)sender{
    
    ECGDetailViewController *detailVC = [[ECGDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
