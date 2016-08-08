//
//  BaseViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.translucent=NO;
    self.tabBarController.tabBar.translucent=NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.translucent=YES;
    self.tabBarController.tabBar.translucent=NO;
}

#pragma mark - left
-(void)initLeftBarButtonItem {
    MyCustomButton *button = [MyCustomButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 44)];
    UIImage *image = [UIImage imageNamed:@"返回黑色"];
    [button setImage:image forState:UIControlStateNormal];
    [button setMyButtonImageFrame:CGRectMake(0, 15, image.size.width/2.5, image.size.height/2.5)];
    [button addTarget:self action:@selector(backToSuper)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)backToSuper {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCustomNavigationLeftBar {
    
    [self initLeftBarButtonItem];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)initrightBarButtonItem:(NSString*)title action:(SEL)action {
    
    
    MyCustomButton *mapbutton = [MyCustomButton buttonWithType:UIButtonTypeCustom];
    [mapbutton setFrame:CGRectMake(0, 0, 60, 44)];
    
    [mapbutton setTitle:title forState:(UIControlStateNormal)];
    mapbutton.titleLabel.font = [UIFont systemFontOfSize:text_size_small];
    
    CGSize titleSize = [mapbutton.titleLabel sizeThatFits:CGSizeMake(60, 44)];
    [mapbutton setTitleColor:UIColorFromRGB(0x0097ff) forState:(UIControlStateNormal)];
    [mapbutton setMyButtonContentFrame:CGRectMake(60 - titleSize.width, 10, titleSize.width, 25)];
    [mapbutton addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:mapbutton];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
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
