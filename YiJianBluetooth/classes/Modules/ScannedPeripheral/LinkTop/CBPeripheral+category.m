//
//  CBPeripheral+category.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/17.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "CBPeripheral+category.h"
#import <objc/runtime.h>

@implementation CBPeripheral (category)
//定义常量 必须是C语言字符串
static char NameKey ;


- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, &NameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)getName{
    return objc_getAssociatedObject(self, &NameKey);
}

@end
