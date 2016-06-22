//
//  ProductModel.m
//  UPJStore
//
//  Created by upj on 16/3/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.productId = value;
    }
}

@end
