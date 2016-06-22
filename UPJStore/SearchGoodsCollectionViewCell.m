//
//  SearchGoodsCollectionViewCell.m
//  UPJStore
//
//  Created by upj on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "SearchGoodsCollectionViewCell.h"
#import "UIView+cg.h"
#define  kSwidth self.bounds.size.width
#define kSheight self.bounds.size.height

@implementation SearchGoodsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8.0*kSheight/9, kSwidth, kSheight/9.0)];
        _priceLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
        _priceLabel.textColor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLabel];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 6.0*kSheight/9, kSwidth, kSheight*2.0/9)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:_titleLabel];
        
        _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSwidth, kSheight*6.0/9)];
        [self addSubview:_goodsImageView];
    }
    return self;

}

@end
