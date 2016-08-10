//
//  MainViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "MainTabBarController.h"
#import "TypeViewController.h"
#import "ReportViewController.h"
#import "ServiceViewController.h"
#import "MineViewController.h"
#import "ShoppingMallViewController.h"

#import "AlarmClockViewController.h"

@interface MainTabBarController ()

@property (nonatomic, strong)NSMutableArray *itemArray;


@end

@implementation MainTabBarController
- (NSMutableArray *)itemArray
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    /** 设置默认状态 */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    /** 设置选中状态 */
    NSMutableDictionary *selDict = @{}.mutableCopy;
    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
    selDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self addController];
}

-(void)addController{

    /*添加子控制器 */
    /** 商城 */
    [self setUpChildControllerWith:[[ShoppingMallViewController alloc]init] norImage:[UIImage imageNamed:@"tabBar_me_icon"] selImage:[UIImage imageNamed:@"tabBar_me_click_icon"] title:@"商城"];
    
    /** 报告 */
    [self setUpChildControllerWith:[[ReportViewController alloc] init] norImage:[UIImage imageNamed:@"tabBar_new_icon"] selImage:[UIImage imageNamed:@"tabBar_new_click_icon"]title:@"报告"];
    
    
    /** 首页 */
    [self setUpChildControllerWith:[[TypeViewController alloc]init] norImage:[UIImage imageNamed:@"tabBar_essence_icon"] selImage:[UIImage imageNamed:@"tabBar_essence_click_icon"] title:@"首页"];

    /** 服务 */
    [self setUpChildControllerWith:[[ServiceViewController alloc] init] norImage:[UIImage imageNamed:@"tabBar_friendTrends_icon"] selImage:[UIImage imageNamed:@"tabBar_friendTrends_click_icon"] title:@"服务"];
    
    /** 我的 */
    [self setUpChildControllerWith:[[MineViewController alloc] init] norImage:[UIImage imageNamed:@"tabBar_friendTrends_icon"] selImage:[UIImage imageNamed:@"tabBar_friendTrends_click_icon"] title:@"我的"];

    
    //    /** 配置中间按钮 */
    //    [self.tabBar setUpTabBarCenterButton:^(UIButton *centerButton) {
    //        [centerButton setBackgroundImage:[UIImage imageNamed:@"camera_button_take"] forState:UIControlStateNormal];
    //
    //        [centerButton setBackgroundImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte"] forState:UIControlStateSelected];
    //
    //        [centerButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
    //    }];
    
    /** 设置tabar工具条 */
    //    self.tabBar.items = self.itemArray;
    //    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    
    [self.tabBar setBackgroundColor:[UIColor clearColor]];
    
    //    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar-light.png"]; //需要的图片
    //
    //    UIImage* tabBarShadow = [UIImage imageNamed:@"tabbar-light.png"]; //需要的图片
    //
    //    [[UITabBar appearance] setShadowImage:tabBarBackground];
    //
    //    [[UITabBar appearance] setBackgroundImage:tabBarShadow];
    
    self.selectedIndex = 2;
    
}

- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    nav.title=title;
    //    childVc.title = title;
    //
    //    childVc.tabBarItem.image = norImage;
    //    childVc.tabBarItem.selectedImage = selImage;
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.image = norImage;
    tabBarItem.selectedImage = selImage;
    tabBarItem.title = title;
    
    childVc.tabBarItem=tabBarItem;
    /** 添加到模型数组 */
    [self.itemArray addObject:tabBarItem];
    
    [self addChildViewController:nav];
    
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
