//
//  ShoppingCarModel.m
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)setVm:(ShopViewModel *)vm
{
    _vm=vm;
    
    [self addObserver:vm forKeyPath:@"isSelect" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)dealloc
{
    [self removeObserver:_vm forKeyPath:@"isSelect"];
}

@end
