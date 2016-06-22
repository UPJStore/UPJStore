//
//  CustomCollectionViewCell.h
//  UPJStore
//
//  Created by upj on 16/3/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface CustomCollectionViewCell : UICollectionViewCell
//@property (nonatomic,strong)UIButton *productBtn;
@property (nonatomic,strong)UIImageView *productImg;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *productIntroduceLabel;

@property (nonatomic,strong)ProductModel *model;

@end
