//
//  ProductsModel.h
//  UPJStore
//
//  Created by upj on 16/3/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsModel : NSObject

@property (nonatomic,strong) NSString *goodsid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *thumb;
@property (nonatomic,strong) NSString *marketprice;
@property (nonatomic,strong) NSString *productprice;
@property (nonatomic,strong) NSString *sales;
@property (nonatomic,strong) NSString *createtime;
@property (nonatomic,strong) NSString *viewcount;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *country;

@end
