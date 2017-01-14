//
//  NSString+KenStringTool.m
//  UPJStore
//
//  Created by upj on 17/1/14.
//  Copyright © 2017年 UPJApp. All rights reserved.
//


#import "NSString+KenStringTool.h"

@implementation NSString (KenStringTool)

#pragma mark - 判断获取字符串是否为空，防崩溃处理。
+(NSString *)handleTheStringIfIsNull:(id)param
{

    if([param isKindOfClass:[NSString class]]&&[param length]>0)return param;
    return @"";
}

@end
