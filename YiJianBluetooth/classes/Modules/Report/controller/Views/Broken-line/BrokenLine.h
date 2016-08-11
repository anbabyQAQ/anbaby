//
//  BrokenLine.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YiJianBluetooth-Bridging-Header.h"
#import "YiJianBluetooth-Swift.h"

@interface BrokenLine : UIView<ChartViewDelegate>

@property (nonatomic, strong) LineChartView *LineChartView;
@property (nonatomic, strong) LineChartData *lineCData;


@property (nonatomic, assign)BOOL isBloodPressure;

-(instancetype)initWithFrame:(CGRect)frame type:(BOOL)type;

- (LineChartData *)setData;

-(void)updateDataBtnClick;
@end
