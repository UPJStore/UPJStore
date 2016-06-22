//
//  AttentionModel.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/9.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AttentionModel.h"

@implementation AttentionModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.pid = value;
    }
    if ([key isEqualToString:@"name"]) {
        self.title = value;
    }
    if ([key isEqualToString:@"parentid"]) {
        self.cid = value;
    }
}

@end