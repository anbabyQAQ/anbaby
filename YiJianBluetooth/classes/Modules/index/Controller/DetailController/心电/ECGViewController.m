//
//  ECGViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ECGViewController.h"

@interface ECGViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation ECGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"心电";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];

}


- (void)addTableView {
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
//    
//    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-SEGMENT_HEIGHT-NAVIGATION_HEIGHT)];
//    NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
//    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    _tableView.backgroundColor=UIColorFromRGB(0xf3f3f3);
//    
//    [self.view addSubview:_tableView];
//    
//    
//    _noInfoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 270)];
//    _noInfoView.backgroundColor = UIColorFromRGB(0xf3f3f3);
//    UIImageView *noinfoImg = [[UIImageView alloc]initWithFrame:CGRectMake(115, 90, 90, 90)];
//    noinfoImg.image = [UIImage imageNamed:@"暂无数据_03.png"];
//    UILabel *noinfoLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 195, 300, 21)];
//    noinfoLab.textAlignment=NSTextAlignmentCenter;
//    noinfoLab.text=@"暂无数据 ~";
//    noinfoLab.font=[UIFont systemFontOfSize:text_size_smaller];
//    noinfoLab.textColor=[UIColor darkGrayColor];
//    [_noInfoView addSubview:noinfoImg];
//    [_noInfoView addSubview:noinfoLab];
//    _noInfoView.hidden=YES;
//    [self.view addSubview:_noInfoView];
    
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
