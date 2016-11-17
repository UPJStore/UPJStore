//
//  ShopApplyModel.m
//  UPJStore
//
//  Created by upj on 16/11/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShopApplyModel.h"

@implementation ShopApplyModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }
}

@end
