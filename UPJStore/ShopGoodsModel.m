//
//  ShopGoodsModel.m
//  UPJStore
//
//  Created by upj on 16/11/1.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShopGoodsModel.h"

@implementation ShopGoodsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.gid = value;
    }
}

@end
