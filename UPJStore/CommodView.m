//
//  CommodView.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/14.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CommodView.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@implementation CommodView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //商品名字
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(100, 10, 314, 40)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:_nameLabel];
        //价钱
        _moneylabel = [[UILabel alloc]initWithFrame:CGRectMake1(105, 65, 70, 16)];
        _moneylabel.textColor = [UIColor redColor];
        _moneylabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:_moneylabel];
        //数量
        _numberlabel = [[UILabel alloc]initWithFrame:CGRectMake1(165, 67, 36 , 12)];
        _numberlabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        _numberlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:_numberlabel];
        
        _goodDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodDetailBtn.frame = CGRectMake1(0, 0,414,100);
        [self addSubview:_goodDetailBtn];

        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake1(330, 65, 70, 25);
        [_button setTitle:@"评价" forState:UIControlStateNormal];
        [_button.layer setCornerRadius:3];
        [_button.layer setBorderColor:[UIColor colorFromHexRGB:@"babcbb"].CGColor];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button.layer setBorderWidth:0.5];
        _button.backgroundColor = [UIColor whiteColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
        [self addSubview:_button];
        
        
    }
    return self;
}

@end
