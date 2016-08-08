//
//  TypeViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "TypeViewController.h"
#import "TypeCollectionViewCell.h"
#import "TemperatureViewController.h"
#import "AlarmClockViewController.h"
#import "AlarmViewController.h"
#import "ECGViewController.h"

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
@interface TypeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *typeCollertion;


@property(nonatomic, strong)NSArray *typeArray;
@property(nonatomic, strong)NSArray *icon_imgarr;


@end


static NSString *cellInte = @"typeCell";

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    [self.typeCollertion registerNib:[UINib nibWithNibName:@"TypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellInte];
    _typeCollertion.backgroundColor  = [UIColor whiteColor];
    
    self.typeArray   = @[@"体温",@"心电",@"心率",@"血糖",@"血压",@"血氧"];
    self.icon_imgarr = @[@"FeatureHTS",@"FeatureHRS",@"FeatureCSC",@"FeatureBGM",@"FeatureBPM",@"FeatureDFU"];
}

#pragma maek -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    return CGSizeMake((KScreenWidth - 140)/ 3.0, (KScreenWidth - 100)/ 3.0 + 20);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(20,25,0,25);
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
    
    if (indexPath.row == 0) {
        AlarmClockViewController *temp = [[AlarmClockViewController alloc] init];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }else if (indexPath.row == 1){
    
        ECGViewController *ECG = [[ECGViewController alloc] init];
        ECG.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ECG animated:YES];
        
    }else{
    
        TemperatureViewController *temperVC = [[TemperatureViewController alloc] init];
        temperVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temperVC animated:YES];
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
