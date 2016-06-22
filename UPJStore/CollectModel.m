//
//  CollectModel.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/6.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.aid = value;
    }
}

@end
