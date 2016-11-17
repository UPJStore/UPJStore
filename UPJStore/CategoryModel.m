//
//  CategoryModel.m
//  UPJStore
//
//  Created by upj on 16/10/31.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.cateid = value;
    }
}

@end
