//
//  BaseViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (){
    JGProgressHUD *_HUD;
}

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xc62828);
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


#pragma mark - JGProgressHUDDelegate

- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view {
    NSLog(@"HUD %p will present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view {
    NSLog(@"HUD %p did present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view {
    NSLog(@"HUD %p will dismiss from view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view {
    NSLog(@"HUD %p did dismiss from view: %p", progressHUD, view);
}


#pragma mark -


- (void)showSuccessHud:(NSUInteger)section {
    _HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    _HUD.userInteractionEnabled = _blockUserInteraction;
    _HUD.delegate = self;
    
    UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success.png"]];
    _HUD.textLabel.text = @"Success!";
    JGProgressHUDIndicatorView *ind = [[JGProgressHUDIndicatorView alloc] initWithContentView:errorImageView];
    _HUD.progressIndicatorView = ind;
    
    _HUD.square = YES;
    
    [_HUD showInView:self.navigationController.view];
    
}

- (void)showErrorHud:(NSUInteger)section {
    _HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    _HUD.userInteractionEnabled = _blockUserInteraction;
    _HUD.delegate = self;
    
    UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error.png"]];
    _HUD.textLabel.text = @"Error!";
    JGProgressHUDIndicatorView *ind = [[JGProgressHUDIndicatorView alloc] initWithContentView:errorImageView];
    _HUD.progressIndicatorView = ind;
    
    _HUD.square = YES;
    
    [_HUD showInView:self.navigationController.view];
    
}

- (void)showSimpleHud:(NSUInteger)section {
    _HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    _HUD.userInteractionEnabled = _blockUserInteraction;
    _HUD.delegate = self;
    
    [_HUD showInView:self.navigationController.view];
    
}

- (void)showWithTextHud:(NSUInteger)section text:(NSString *)text done:(NSString *)text1{
    _HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    _HUD.textLabel.text = text;
    _HUD.delegate = self;
    _HUD.userInteractionEnabled = _blockUserInteraction;
    [_HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _HUD.useProgressIndicatorView = NO;
        
        _HUD.textLabel.font = [UIFont systemFontOfSize:30.0f];
        
        _HUD.textLabel.text = text1;
        
        _HUD.position = JGProgressHUDPositionBottomCenter;
    });
    
    _HUD.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
    
}

- (void)showProgressHud:(NSUInteger)section text:(NSString *)text{
    _HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    _HUD.progressIndicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:_HUD.style];
    _HUD.delegate = self;
    _HUD.userInteractionEnabled = _blockUserInteraction;
    _HUD.textLabel.text = text;
    [_HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:0.25 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:0.5 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:0.75 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:1.0 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD dismiss];
    });
}

- (void)showZoomAnimationWithRing:(NSUInteger)section text:(NSString *)text{
    _HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    _HUD.progressIndicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:_HUD.style];
    _HUD.userInteractionEnabled = _blockUserInteraction;
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    _HUD.animation = an;
    _HUD.delegate = self;
    _HUD.textLabel.text = text;
    [_HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:0.25 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:0.5 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:0.75 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD setProgress:1.0 animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_HUD dismiss];
    });
}

-(void)showTextOnlyHud:(NSUInteger)section text:(NSString *)text{
    _HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    _HUD.useProgressIndicatorView = NO;
    _HUD.userInteractionEnabled = _blockUserInteraction;
    _HUD.textLabel.text = text;
    _HUD.delegate = self;
    _HUD.position = JGProgressHUDPositionBottomCenter;
    _HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    
    [_HUD showInView:self.navigationController.view];
    
}

- (void)dismissAnimated:(BOOL)animated{
    [_HUD dismissAnimated:animated];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated{
    [_HUD dismissAfterDelay:delay animated:animated];
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
