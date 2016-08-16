
//
//  ChooseUser.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/16.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ChooseUser.h"
#import "Cell.h"
#import "LineLayout.h"

@implementation ChooseUser{
    UICollectionView *_collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
             //先实例化一个层
        
        LineLayout *layout=[[ LineLayout alloc ] init];
        
        
        
        //创建一屏的视图大小
        
        _collectionView=[[ UICollectionView alloc ] initWithFrame : self.bounds collectionViewLayout:layout];
        
        
        
        [_collectionView registerClass :[Cell class ] forCellWithReuseIdentifier : @"cell"];
        
        _collectionView. backgroundColor =[ UIColor whiteColor ];
        
        _collectionView. delegate = self ;
        
        _collectionView. dataSource = self ;
        
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        [ self addSubview :_collectionView];
    }
    
    return self;
}


- (void)setWithUserInfo:(NSArray *)users{
    _array = [NSMutableArray arrayWithArray:users];
    
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    return cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
