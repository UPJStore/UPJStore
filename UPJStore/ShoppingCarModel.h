//
//  ShoppingCarModel.h
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommodityShopModel.h"
#import "ShopViewModel.h"

@interface ShoppingCarModel : NSObject
@property (nonatomic,strong) NSString *total;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) ShopViewModel *vm;
@property (nonatomic,strong) CommodityShopModel *model;

@end
