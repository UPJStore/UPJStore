//
//  ShopViewModel.h
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NumPriceBlock)();

@interface ShopViewModel : NSObject

@property(nonatomic,copy)NumPriceBlock priceBlock;

- (void)getShopData:(void (^)(NSArray * commonArry))shopDataBlock  priceBlock:(void (^)()) priceBlock WithDic:(NSDictionary *)resdic;

- (void)getNumPrices:(void (^)()) priceBlock;

-(void)clickAllBT:(NSMutableArray *)carDataArrList bt:(UIButton *)bt;

- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type;

- (void)pitchOn:(NSMutableArray *)carDataArrList;

@end
