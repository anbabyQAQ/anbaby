//
//  HttpBaseResponse.h
//  mts-iphone
//
//  Created by tyl on 16/8/4.
//  Copyright (c) 2016年 中国电信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpBaseResponse : NSObject{
    NSNumber* _code;//liuchao520
    NSString* _message;
    NSDate* _serverTime;
    
}
@property (nonatomic , strong)NSNumber * code; //atomic
@property NSString* message;
@property NSDate* serverTime;

-(void)setWithJson:(NSString*) dic_json;

-(id)initWithJson:(NSString*) resultString;


@end
