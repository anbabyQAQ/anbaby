//
//  DimensionUtil.m
//  mts-iphone
//
//  Created by 李曜 on 15/4/16.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//
//#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
//
#import "DimensionUtil.h"

@implementation DimensionUtil

//+(NSInteger)getHeight:(NSInteger) heightOf568{
//    return SCR_H*heightOf568/568;
//
//}
//
//+(NSInteger)getWidth:(NSInteger) widthOf320{
//return SCR_W*widthOf320/320;
//
//}

+(CGFloat) ViewPositionY:(UIView *) view{

    return view.frame.origin.y+view.frame.size.height;
    

}

+(CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(NSInteger)width{
    
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width,999 )
                   
                       lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat delta = size.height+10;
    
    return delta;

}

+ (void)setFontByDevice {
    if (SCREEN_MAX_LENGTH < 568.0) {    //4s
        
        font_size_navigation_title  = 16.0f;
        font_size_navigation_item   = 16.0f;
        font_size_segment_title     = 14.0f;
        font_size_text_huge         = 18.0f;
        font_size_text_large        = 16.0f;
        font_size_text_normal       = 15.0f;
        font_size_text_small        = 14.0f;
        font_size_text_smaller      = 13.0f;
        font_size_text_tiny         = 12.0f;
        
    }else if(SCREEN_MAX_LENGTH == 568.0) { //5
        
        font_size_navigation_title  = 16.0f;
        font_size_navigation_item   = 16.0f;
        font_size_segment_title     = 14.0f;
        font_size_text_huge         = 18.0f;
        font_size_text_large        = 16.0f;
        font_size_text_normal       = 15.0f;
        font_size_text_small        = 14.0f;
        font_size_text_smaller      = 13.0f;
        font_size_text_tiny         = 12.0f;

    }else if(SCREEN_MAX_LENGTH == 667.0) { //6
        
        font_size_navigation_title  = 16.0f;
        font_size_navigation_item   = 16.0f;
        font_size_segment_title     = 14.0f;
        font_size_text_huge         = 18.0f;
        font_size_text_large        = 16.0f;
        font_size_text_normal       = 15.0f;
        font_size_text_small        = 14.0f;
        font_size_text_smaller      = 13.0f;
        font_size_text_tiny         = 12.0f;

    }else if(SCREEN_MAX_LENGTH == 736.0) {  //6s
        
        font_size_navigation_title  = 16.0f;
        font_size_navigation_item   = 16.0f;
        font_size_segment_title     = 14.0f;
        font_size_text_huge         = 18.0f;
        font_size_text_large        = 16.0f;
        font_size_text_normal       = 15.0f;
        font_size_text_small        = 14.0f;
        font_size_text_smaller      = 13.0f;
        font_size_text_tiny         = 12.0f;

    }
}
@end
