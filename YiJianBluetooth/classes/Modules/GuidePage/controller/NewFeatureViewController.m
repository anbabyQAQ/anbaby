//
//  NewFeatureViewController.m
//  YueBa
//
//  Created by zhaoxu on 15/9/22.
//  Copyright © 2015年 YyJd. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"

#define WMColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface NewFeatureViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    //添加UIScrollView
    [self setUpScrollView];
    //添加pageControl
    [self setupPageControl];
    // Do any additional setup after loading the view.
}

//添加UIScrollView
- (void)setupPageControl
{
    //1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 3;
    CGFloat centerX = self.view.frame.size.width * 0.5;
    CGFloat centerY = self.view.frame.size.height - 30;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    //设置原点的颜色
    pageControl.currentPageIndicatorTintColor = WMColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = WMColor(189, 189, 189);
}

- (void)setUpScrollView
{
    //设置背景
    //    self.view.backgroundColor = WMColor(246, 246, 246);
    //添加UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    //添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int index = 0; index < 3; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //设置图片
        NSString *name = [NSString stringWithFormat:@"guide_%d.png", index + 1];
        imageView.image = [UIImage imageNamed:name];
        //设置frame
        CGFloat imageX = index *imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        [scrollView addSubview:imageView];
        
        //在最后一个图片上面添加按钮
        if (index == 2) {
            [self setupLastImageView:imageView];
        } else {
            [self setupOtherImageView:imageView];
        }
    }
    //设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * 3, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
}

- (void)setupOtherImageView:(UIImageView *)imageView {
    //让imageView能跟用户交互
    imageView.userInteractionEnabled = YES;
    
    //添加开始按钮
    UIButton *skipButton = [[UIButton alloc] init];
    skipButton.backgroundColor = [UIColor clearColor];
    //2.设置frame
    CGFloat centerX = imageView.frame.size.width;
    CGFloat centerY = imageView.frame.size.height;
    skipButton.center = CGPointMake(centerX, centerY);
    if (SCR_H>=500) {
        skipButton.frame = CGRectMake(centerX-110, centerY-50, 100, 20);
    } else {
        skipButton.frame = CGRectMake(centerX-100, centerY-30, 100, 20);
    }
    
    //设置文字
    [skipButton setTitle:@"跳过 SKIP" forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:skipButton];
}

/**
 *  添加内容到最后一个图片
 */

- (void)setupLastImageView:(UIImageView *)imageView
{
    //让imageView能跟用户交互
    imageView.userInteractionEnabled = YES;
    
    //添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    startButton.backgroundColor = [UIColor clearColor];
    startButton.layer.cornerRadius = 10;
    startButton.layer.masksToBounds = YES;
    startButton.layer.borderWidth = 2;
    startButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //2.设置frame
    CGFloat centerX = imageView.frame.size.width * 0.5;
    CGFloat centerY = imageView.frame.size.height * 0.75;
    startButton.center = CGPointMake(centerX, centerY);
    startButton.frame = CGRectMake(centerX-80, centerY, 160, 40);
    //设置文字
    [startButton setTitle:@"立即进入" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
}
//开始微博
- (void)start
{
    //显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"first"];
    //切换窗口的根控制器
    
    MainTabBarController *main = [[MainTabBarController alloc] init];
    //重新制定根控制器
    [[UIApplication sharedApplication].keyWindow setRootViewController:main];

//    [UIApplication sharedApplication].keyWindow.rootViewController
}


- (void)checkboxClick:(UIButton *)checkbox
{
    checkbox.selected = !checkbox.isSelected;
}

/**
 *  只要UIScrollView滚动了，就会调用
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //求出野马
    double pageDouble = offsetX/scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
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
