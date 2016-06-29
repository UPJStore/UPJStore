//
//  LBTModel.m
//  UPJStore
//
//  Created by upj on 16/3/14.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "LBTModel.h"

@implementation LBTModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.lbid = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptionStr = value;
    }
    
}

@end

