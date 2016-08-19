//
//  TypeViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TypeViewController.h"
#import "TypeCollectionViewCell.h"
#import "TempViewController.h"
#import "AlarmClockViewController.h"
#import "AlarmViewController.h"
#import "ECGViewController.h"
#import "UsersDao.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "HeartRateSetViewController.h"
#import "BSViewController.h"//血糖
#import "BPViewController.h"//血压
#import "BOViewController.h"//血氧

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
@interface TypeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *typeCollertion;


@property(nonatomic, strong)NSArray *typeArray;
@property(nonatomic, strong)NSArray *icon_imgarr;

/**
 *  无限轮播要使用的数组
 */
@property (nonatomic, strong) NSMutableArray *bannerImageArray;

/**
 *  真实数量的图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;


@end


static NSString *cellInte = @"typeCell";

@implementation TypeViewController

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

- (NSMutableArray *)bannerImageArray {
    if (_bannerImageArray == nil) {
        _bannerImageArray = [[NSMutableArray alloc]init];
    }
    return _bannerImageArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    [self initCollertionview];

    [self setCarrousel];
    
    self.typeArray   = @[@"体温",@"血压",@"血糖",@"血氧",@"心率",@"心电"];
    self.icon_imgarr = @[@"体温",@"血压",@"血糖",@"血氧",@"心率",@"心电"];
}

- (void)initCollertionview{
    [self.typeCollertion registerNib:[UINib nibWithNibName:@"TypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellInte];
    _typeCollertion.backgroundColor  = [UIColor whiteColor];
    
    //这个地方一定要写，不然会crash
    [self.typeCollertion registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    //代码控制header和footer的显示
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.typeCollertion.collectionViewLayout;
    collectionViewLayout.headerReferenceSize = CGSizeMake(SCR_W, 170);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(SCR_W, 170);  //设置head大小
}

-(void)setCarrousel{
    for (int index = 0; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite0%d.jpg",index]];
        [self.imageArray addObject:image];
    }
    
    
    for (NSInteger imageIndex = 0; imageIndex < 3; imageIndex ++) {
        [self.bannerImageArray addObjectsFromArray:self.imageArray];
    }
    
    [self setupUI];

}

- (void)setupUI {
    
    
    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 10, SCR_W, 150)];
    _pageFlowView.backgroundColor = [UIColor whiteColor];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.4;
    _pageFlowView.minimumPageScale = 0.85;
    _pageFlowView.orginPageCount = self.imageArray.count;
    
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 20, SCR_W, 8)];
    _pageFlowView.pageControl = pageControl;
    [_pageFlowView addSubview:pageControl];
    [_pageFlowView startTimer];
    
    [_typeCollertion addSubview:_pageFlowView];
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(SCR_W -84, (SCR_W - 84) * 9 / 16);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return [self.bannerImageArray count];
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, SCR_W - 84, (SCR_W - 84) * 9 / 16)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.bannerImageArray[index];
    bannerView.allCoverButton.tag = index;
    [bannerView.allCoverButton addTarget:self action:@selector(didSelectBannerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return bannerView;
}

#pragma mark --点击轮播图
- (void)didSelectBannerButtonClick:(UIButton *) sender {
    
    NSInteger index = sender.tag % self.imageArray.count;
    
    NSLog(@"点击了第%ld张图",(long)index);
    
}




#pragma maek -UICollectionViewDelegateFlowLayout
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        reusableview = headerView;
    }
    
    return reusableview;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    return CGSizeMake((KScreenWidth - 170)/ 3.0, (KScreenWidth - 110)/ 3.0 +5);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(30,28,0,28);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 25;
}

//列
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.typeArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellInte forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *icon_img = self.icon_imgarr[indexPath.row];
    cell.icon_imgview.image = [UIImage imageNamed:icon_img];
    cell.typeLabel.text = self.typeArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:1] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    if (indexPath.row == 0) {
        TempViewController *temp = [[TempViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }else if (indexPath.row == 1){
    
        BPViewController *bpVC = [[BPViewController alloc] init];
        bpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bpVC animated:YES];
        
        
    }else if (indexPath.row == 2){
    
        BSViewController *bsVC = [[BSViewController alloc] init];
        bsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bsVC animated:YES];
        
    }else if (indexPath.row == 3){
    
        BOViewController *boVC = [[BOViewController alloc] init];
        boVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:boVC animated:YES];
    }else if (indexPath.row == 4){
    
        HeartRateSetViewController *rateVC = [[HeartRateSetViewController alloc] init];
        rateVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rateVC animated:YES];
        
    }else if (indexPath.row == 5){
    
        ECGViewController *ECG = [[ECGViewController alloc] init];
        ECG.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ECG animated:YES];

    }
    
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
