//
//  ShopViewModel.m
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShopViewModel.h"
#import "MJExtension.h"
#import "ShoppingCarModel.h"
#import "CommodityShopModel.h"
#import "AFNetWorking.h"



@interface ShopViewModel ()
{
    NSMutableArray * commonMuList;
    NSMutableArray * commArr;
}
@end


@implementation ShopViewModel

-(void)getNumPrices:(void (^)())priceBlock
{
    _priceBlock = priceBlock;
}

- (void)getShopData:(void (^)(NSArray * commonArry))shopDataBlock  priceBlock:(void (^)()) priceBlock WithDic:(NSDictionary *)resdic
{
        commonMuList = [NSMutableArray array];
        commArr = [NSMutableArray array];
        NSArray * arr =[resdic valueForKey:@"data"] ;
        for (NSDictionary * dic in arr)
        {
            ShoppingCarModel *NewModel =[ShoppingCarModel mj_objectWithKeyValues:resdic];

            NewModel.model = [CommodityShopModel mj_objectWithKeyValues:dic];
            DLog(@"dic = %@",dic);
            DLog(@"is_choose = %@",NewModel.model.is_choose);
            
            NewModel.model.listId = [dic valueForKey:@"id"];
            [commArr addObject:NewModel.model];
            NewModel.vm =self;
            NewModel.type=1;
            if ([NewModel.model.is_choose isEqualToString:@"0"] ||NewModel.model.is_choose ==nil)
            {
                NewModel.isSelect = NO;
            }
            else
            {
                NewModel.isSelect = YES;
            }
         
            [commonMuList addObject:NewModel];
        }
        
        if (commonMuList.count>0) {
            
            [commonMuList addObject:[self verificationSelect:commonMuList type:@"1"]];
            
            _priceBlock = priceBlock;
            shopDataBlock(commonMuList);
        }
    
    }
- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"YES" forKey:@"checked"];
    [dic setObject:type forKey:@"type"];
    for (int i =0; i<arr.count; i++)
    {
        DLog(@"i = %d",i);
        ShoppingCarModel *model = (ShoppingCarModel*)[arr objectAtIndex:i];
        
        if (!model.isSelect)
        {
            [dic setObject:@"NO" forKey:@"checked"];
            break;
        }
    }
    
    return dic;
}


- (void)pitchOn:(NSMutableArray *)carDataArrList
{
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        
        NSMutableDictionary *dic = [dataList lastObject];
        [dic setObject:@"YES" forKey:@"checked"];
        for (int j=0; j<dataList.count-1; j++) {
            ShoppingCarModel *model = (ShoppingCarModel *)[dataList objectAtIndex:j];
            if (model.type==1 ) {
                if (!model.isSelect && ![model.model.is_choose isEqualToString:@"0"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    break;
                }
                
            }
        }
    }
}


-(void)clickAllBT:(NSMutableArray *)carDataArrList bt:(UIButton *)bt
{
    
    bt.selected = !bt.selected;
    
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
        for (int j=0; j<dataList.count-1; j++) {
            ShoppingCarModel *model = (ShoppingCarModel *)[dataList objectAtIndex:j];
            if (model.type==1 && bt.tag==100) {
                if (bt.selected)
                {
                    [dic setObject:@"YES" forKey:@"checked"];
                }
                else
                {
                    [dic setObject:@"NO" forKey:@"checked"];
                }
                if ([model.model.is_choose isEqualToString:@"0"]) {
                    continue;
                }
                else{
                    model.isSelect=bt.selected;
                
                }
                
            }
            
        }
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    DLog(@"开始计算价钱");
    if ([keyPath isEqualToString:@"isSelect"]) {
        if (_priceBlock!=nil) {
            _priceBlock();
        }
        
    }
}



@end
