//
//  MemberModel.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel
- (id)init {
    if (self=[super init]) {
        
        _member_agent_id = @"0";
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.mid = value;
    }
}

@end
