//
//  User.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWith:(NSDictionary*) dic{
    if(dic){
        
        self.name=[DataUtil stringForKey:@"aliasName" inDictionary:dic];
        self.phone=[DataUtil stringForKey:@"phone" inDictionary:dic];
        self.age=[DataUtil stringForKey:@"age" inDictionary:dic];

        self.weight=[[DataUtil numberForKey:@"weight" inDictionary:dic] integerValue];
        self.height=[[DataUtil numberForKey:@"height" inDictionary:dic] integerValue];
        self.uid=[[DataUtil numberForKey:@"uid" inDictionary:dic] stringValue];
        
        if ([[DataUtil numberForKey:@"uid" inDictionary:dic] integerValue]) {
            self.gender=1;
        }else{
            self.gender=0;
        }
        
      
        
        return self;
    }
    return nil;
}


-(NSDictionary*)dictionary{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
  
    return dic;
    
}
@end
