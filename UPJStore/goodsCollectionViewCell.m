//
//  goodsCollectionViewCell.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/18.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "goodsCollectionViewCell.h"

@implementation goodsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.goodsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height-15)];
        [self.contentView addSubview:self.goodsView];
        self.goodsView.contentMode = UIViewContentModeScaleAspectFit;
        _goodsView.layer.cornerRadius = 10;
        _goodsView.layer.masksToBounds =YES;
        _goodsView.layer.borderWidth = 1;
        _goodsView.layer.borderColor = [[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]CGColor];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-15, self.contentView.frame.size.width, 15)];
        self.nameLabel.font = [UIFont systemFontOfSize:10];
        [self.nameLabel setTextColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1]];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        
        
    }
    return self;
}

@end
