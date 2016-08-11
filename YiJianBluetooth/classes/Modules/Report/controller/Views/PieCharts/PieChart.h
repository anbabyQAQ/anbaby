//
//  PieChart.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Charts/Charts.h>
#import "YiJianBluetooth-Bridging-Header.h"
#import "YiJianBluetooth-Swift.h"


@interface PieChart : UIView

//饼图
@property (nonatomic, strong) PieChartView *pieChartView;
@property (nonatomic, strong) PieChartData *data;

-(instancetype)initWithFrame:(CGRect)frame;


- (PieChartData *)setPieData;
@end
