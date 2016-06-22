//
//  HeaderModel.m
//  UPJStore
//
//  Created by upj on 16/3/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "HeaderModel.h"

@implementation HeaderModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    // 替换带有系统关键字的key
    if ([key isEqualToString:@"id"]) {
        self.pid = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptionStr = value;
    }
}
@end
