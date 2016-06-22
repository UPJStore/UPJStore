//
//  OthersModel.m
//  UPJStore
//
//  Created by upj on 16/3/29.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OthersModel.h"

@implementation OthersModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.cid = value;
    }
}
@end
