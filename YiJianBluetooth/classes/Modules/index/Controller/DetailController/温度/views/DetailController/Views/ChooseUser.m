
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
#import "AddCell.h"

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
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        
        LineLayout *layout=[[ LineLayout alloc ] init];

        //创建一屏的视图大小
        
        _collectionView=[[ UICollectionView alloc ] initWithFrame:self.bounds collectionViewLayout:layout];

        [_collectionView registerClass :[Cell class ] forCellWithReuseIdentifier : @"cell"];
        [_collectionView registerClass :[AddCell class ] forCellWithReuseIdentifier : @"addcell"];

        _collectionView. backgroundColor =[UIColor clearColor];
        
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
    
    [_collectionView reloadData];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(60, 80);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(5,5,0,0);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return _array.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row>=_array.count) {
        AddCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"addcell" forIndexPath:indexPath];
        return cell;
    }else{
        
        Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (_array) {
            cell.user = _array[indexPath.row];
        }
        return cell;

    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
    
//    [self updateCollectionViewCellStatus:cell selected:YES];
    if (indexPath.row>=_array.count) {
        if ([self.user_delegate respondsToSelector:@selector(callBaceAddUser)]) {
            [self.user_delegate callBaceAddUser];
        }
    }else{
        if ([self.user_delegate respondsToSelector:@selector(callBackUser:)]) {
            [self.user_delegate callBackUser:_array[indexPath.row]];
        }
    }
}


-(void)updateCollectionViewCellStatus:(Cell *)myCollectionCell selected:(BOOL)selected
{

    myCollectionCell.backgroundColor = selected ? UIColorFromRGB(0xc62828):[UIColor clearColor];
    
}

@end
