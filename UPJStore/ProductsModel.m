//
//  ProductsModel.m
//  UPJStore
//
//  Created by upj on 16/3/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ProductsModel.h"

@implementation ProductsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.productID = value;
    }
}

@end
