//
//  ProductModel.h
//  UPJStore
//
//  Created by upj on 16/3/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, strong)NSString *productId;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *marketprice;
@property (nonatomic, strong)NSString *productprice;
@property (nonatomic, strong)NSString *sales;
@property (nonatomic, strong)NSString *thumb;
@property (nonatomic, strong)NSString *descriptionStr;
@property (nonatomic, strong)NSString *img;
@property (nonatomic, strong)NSString *pcate;
@property (nonatomic, strong)NSString *country;

@end
