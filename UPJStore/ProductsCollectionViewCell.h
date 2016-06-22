//
//  ProductsCollectionViewCell.h
//  UPJStore
//
//  Created by upj on 16/3/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"

@interface ProductsCollectionViewCell : UICollectionViewCell

//@property (nonatomic,strong)UIButton *productBtn;
@property (nonatomic,strong)UIImageView *productImg;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *priceLabel;

@property (nonatomic,strong)ProductsModel *model;


@end
