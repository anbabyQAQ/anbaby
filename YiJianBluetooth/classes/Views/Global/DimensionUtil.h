//
//  DimensionUtil.h
//  mts-iphone
//
//  Created by 李曜 on 15/4/16.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Availability.h>

//#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//
//#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
//
//
//#if IS_IPHONE_4_OR_LESS
//
#define text_size_huge 22.0f
#define text_size_large 18.0f
#define text_size_between_largeAndNormal 17
#define text_size_normal 16.0f
#define text_size_between_normalAndSmall 15
#define text_size_small 14.0f
#define text_size_between_smallAndSmaller 13
#define text_size_smaller 12.0f
#define text_size_tiny 10.0f

//iOS_fontsize * 72 / 96 = ps_size
//用于导航标题
#define text_size_36PX 14.0f
//用于标签，列表等大部分重要标题 如标签，标题名称
#define text_size_34PX 12.75f
//用于大多数文字和按钮
#define text_size_32PX 12.0f
//用于辅助性文字， 如次级辅助文字
#define text_size_30PX 11.25f
//主界面模块标题
#define text_size_28PX 10.5f
//主界面低栏标题
#define text_size_24PX 9.0f

static CGFloat font_size_navigation_title;
static CGFloat font_size_navigation_item;
static CGFloat font_size_segment_title;
static CGFloat font_size_text_huge;
static CGFloat font_size_text_large;
static CGFloat font_size_text_normal;
static CGFloat font_size_text_small;
static CGFloat font_size_text_smaller;
static CGFloat font_size_text_tiny;

@interface DimensionUtil : NSObject

+(CGFloat) ViewPositionY:(UIView *) view;

+(CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(NSInteger)width;

+ (void)setFontByDevice;
@end
