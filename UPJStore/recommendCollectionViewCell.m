//
//  recommendCollectionViewCell.m
//  UPJStore
//
//  Created by upj on 16/3/2.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "recommendCollectionViewCell.h"

@implementation recommendCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        self.goodsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-45)];
        self.goodsView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-45, self.bounds.size.width,30)];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.priceLabel  = [[UILabel alloc ]initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 15)];
        self.priceLabel.textColor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.font = [UIFont systemFontOfSize:12];
        self.priceLabel.numberOfLines = 0;
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.goodsView];
        
        
        
        
        
    }
    
    
    return self;
}

@end
