//
//  Commodity.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OrderModel.h"
#import "CommodModel.h"

@implementation OrderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.orderid = value;
    }
    if ([key isEqualToString:@"goods"]) {
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dic in value) {
            CommodModel *model = [CommodModel new];
            [model setValuesForKeysWithDictionary:dic];
            [tempArr addObject:model];
        }
        self.goodArr = [NSArray arrayWithArray:tempArr];
    }
}


@end
