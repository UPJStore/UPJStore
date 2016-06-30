//
//  SecKillModel.m
//  UPJStore
//
//  Created by upj on 16/6/29.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "SecKillModel.h"

@implementation SecKillModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.secid = value;
    }
}




@end
