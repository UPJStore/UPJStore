//
//  recommandCell.m
//  UPJStore
//
//  Created by upj on 16/6/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "recommandCell.h"
#import "UIView+cg.h"
#import "UIColor+HexRGB.h"
#define  kSwidth self.bounds.size.width
#define kSheight self.bounds.size.height

@implementation recommandCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _productLabel = [[LineLabel alloc]initWithFrame:CGRectMake(kSwidth/2,CGFloatMakeY(165), kSwidth/2,CGFloatMakeY(40))];
        _productLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        _productLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        _productLabel.textAlignment = NSTextAlignmentLeft;
        _productLabel.lineType = LineTypeMiddle;
        [self addSubview:_productLabel];
        
        _marketLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(165), kSwidth/2,CGFloatMakeY(40))];
        _marketLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        _marketLabel.textColor = [UIColor colorFromHexRGB:@"cc2245"];
        _marketLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_marketLabel];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(120), kSwidth,CGFloatMakeY(40))];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorFromHexRGB:@"000000"];
        _titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:_titleLabel];
        
        _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSwidth, CGFloatMakeY(110))];
        [self addSubview:_goodsImageView];
    }
    return self;
    
}
@end
