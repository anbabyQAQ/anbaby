//
//  LeadPlayer.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECGChartViewController;

@interface LeadPlayer : UIView <UIGestureRecognizerDelegate> {
    CGPoint drawingPoints[1000];
    CGPoint endPoint, endPoint2, endPoint3, viewCenter;
    int currentPoint;
    CGContextRef context;
    
    ECGChartViewController *__unsafe_unretained liveMonitor;
    
    NSMutableArray *pointsArray;
    int index;
    NSString *label;
    
    int count;
    UIView *lightSpot;
    int pos_x_offset;
}

@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) UIView *lightSpot;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, unsafe_unretained) ECGChartViewController *liveMonitor;

@property (nonatomic) int index;
@property (nonatomic) int currentPoint;
@property (nonatomic) int pos_x_offset;
@property (nonatomic) CGPoint viewCenter;


- (void)fireDrawing;
- (void)drawGrid:(CGContextRef)ctx;
- (void)drawCurve:(CGContextRef)ctx;
- (void)drawLabel:(CGContextRef)ctx;
- (void)clearDrawing;
- (void)redraw;
- (CGFloat)getPosX:(int)tick;
- (BOOL)pointAvailable:(NSInteger)pointIndex;
- (void)resetBuffer;
- (void)addGestureRecgonizer;

@end
