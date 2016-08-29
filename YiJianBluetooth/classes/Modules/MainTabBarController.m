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
//    // 通过appearance统一设置所有UITabBarItem的文字属性
//    UITabBarItem *tabBarItem = [UITabBarItem appearance];
//    
//    /** 设置默认状态 */
//    NSMutableDictionary *norDict = @{}.mutableCopy;
//    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
//    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
//    
//    /** 设置选中状态 */
//    NSMutableDictionary *selDict = @{}.mutableCopy;
//    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
//    selDict[NSForegroundColorAttributeName] = [UIColor blackColor];
//    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tabBar.tintColor = UIColorFromRGB(0xc62828);
    
    [self addController];
}

-(void)addController{

    /*添加子控制器 */
    /** 商城 */
    [self setUpChildControllerWith:[[ShoppingMallViewController alloc]init] norImage:[UIImage imageNamed:@"shopping_1"] selImage:[UIImage imageNamed:@"shopping_2"] title:@"商城"];
    
    /** 报告 */
    [self setUpChildControllerWith:[[ReportViewController alloc] init] norImage:[UIImage imageNamed:@"report_1"] selImage:[UIImage imageNamed:@"report_2"]title:@"报告"];
    
    
    /** 首页 */
    [self setUpChildControllerWith:[[TypeViewController alloc]init] norImage:[UIImage imageNamed:@"home"] selImage:[UIImage imageNamed:@"home"] title:nil];

    /** 服务 */
    [self setUpChildControllerWith:[[ServiceViewController alloc] init] norImage:[UIImage imageNamed:@"other_1"] selImage:[UIImage imageNamed:@"other_2"] title:@"服务"];
    
    /** 我的 */
    [self setUpChildControllerWith:[[MineViewController alloc] init] norImage:[UIImage imageNamed:@"mine_1"] selImage:[UIImage imageNamed:@"mine_2"] title:@"我的"];

    
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
    
//    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    
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
    SBNvc *nav = [[SBNvc alloc]initWithRootViewController:childVc];

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    nav.title=title;

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
