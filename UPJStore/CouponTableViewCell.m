//
//  CouponTableViewCell.m
//  UPJStore
//
//  Created by 邝健锋 on 16/5/4.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"
@implementation CouponTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *couponView = [[UIView alloc]initWithFrame:CGRectMake1(26, 5, 362, 90)];
        [self addSubview:couponView];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"couponbackground@3x"]];
        imageView.frame = CGRectMake1(0, 0, 362, 90);
        [couponView addSubview:imageView];
        
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 10, 362, 16)];
        _label1.text = @"优惠券";
        _label1.textColor = [UIColor colorFromHexRGB:@"666666"];
        _label1.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [couponView addSubview:_label1];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 35, 150, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        _timeLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        [couponView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 65, 150, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        _contentLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        [couponView addSubview:_contentLabel];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(242, 10, 100, 40)];
        _moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(28)];
        _moneyLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        _moneyLabel.textAlignment = 2;
        [couponView addSubview:_moneyLabel];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier FromCoupon:(BOOL)isFrom
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *couponView = [[UIView alloc]initWithFrame:CGRectMake1(5, 5, 414-80-30-10, 80)];
        [self addSubview:couponView];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"couponbackground@3x"]];
        imageView.frame = CGRectMake1(0, 0, 414-80-40, 80);
        [couponView addSubview:imageView];
        
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 10, 414-80-40, 16)];
        _label1.text = @"优惠券";
        _label1.textColor = [UIColor colorFromHexRGB:@"666666"];
        _label1.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [couponView addSubview:_label1];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 35, 150, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        _timeLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        [couponView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 55, 414-80-50, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        _contentLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        [couponView addSubview:_contentLabel];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(242, 10, 100, 40)];
        _moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(28)];
        _moneyLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        _moneyLabel.textAlignment = 2;
        [couponView addSubview:_moneyLabel];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
