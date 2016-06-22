//
//  OrderModel.m
//  UPJStore
//
//  Created by upj on 16/4/12.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CommodModel.h"

@implementation CommodModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }
}
@end
