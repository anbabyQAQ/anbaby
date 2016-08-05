//
//  HttpBaseResponse.m
//  mts-iphone
//
//  Created by tyl on 16/8/4.
//  Copyright (c) 2016年 中国电信. All rights reserved.
//

#import "HttpBaseResponse.h"

@implementation HttpBaseResponse

-(void)setWithJson:(NSString*) resultString{
    NSDictionary* dic= [resultString JSONValue];
    self.code=[dic objectForKey:@"code"];
    self.message=[dic objectForKey:@"message"];
    self.serverTime=[DateUtil MilliSecondsToDate:[dic objectForKey:@"serverTime"]];

}


-(id)initWithJson:(NSString*) resultString{

    [self setWithJson:resultString];
    return self;

}
@end
