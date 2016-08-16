//
//  ActivityModel.m
//  UPJStore
//
//  Created by upj on 16/8/16.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptionStr = value;
    }
}

@end
