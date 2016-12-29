//
//  ProductTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/7/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "UIViewController+CG.h"
#import "myUILabel.h"
#import "LineLabel.h"

@implementation ProductTableViewCell
{
    UIImageView *imageView;
    UIImageView *countryView;
    myUILabel *titleLabel;
    UILabel *marketpriceLabel;
    LineLabel *productpriceLabel;
    UILabel *discountLabel;
    UIImageView *collectimageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ProductModel *)model
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    [countryView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.upinkji.com/resource/attachment/%@",model.country]] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    titleLabel.text = model.title;
    marketpriceLabel.text = model.marketprice;
    productpriceLabel.text = model.productprice;
    discountLabel.text = [self discountWithmarketPrice:model.marketprice WithproductPrice:model.productprice];
    _buyButton.tag = model.productId.integerValue;
    _collectButton.tag = model.productId.integerValue;
}

-(void)setIscollect:(BOOL)iscollect
{
    if (iscollect) {
        collectimageView.image = [UIImage imageNamed:@"isCollection-YES"];
         [_collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
    }else
    {
        collectimageView.image = [UIImage imageNamed:@"isCollection-NO"];
         [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    }
}
 
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        countryView = [[UIImageView alloc]initWithFrame:CGRectMake1(113, 10, 22, 20)];
        [self addSubview:countryView];
        
        titleLabel = [[myUILabel alloc]initWithFrame:CGRectMake1(135, 10, 270, 50)];
        [titleLabel setVerticalAlignment:VerticalAlignmentTop];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:titleLabel];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(115, 65, 50, 20)];
        label1.text = @"优惠价:";
        label1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake1(115, 90, 40, 20)];
        label2.text = @"市价:";
        label2.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:label2];
        
        marketpriceLabel = [[UILabel alloc]initWithFrame:CGRectMake1(160, 65, 70, 20)];
        marketpriceLabel.textColor = [UIColor redColor];
        marketpriceLabel.font = [UIFont boldSystemFontOfSize:CGFloatMakeY(18)];
        [self addSubview:marketpriceLabel];
        
        productpriceLabel = [[LineLabel alloc]initWithFrame:CGRectMake1(150, 90, 60, 20)];
        productpriceLabel.lineType = LineTypeMiddle;
        productpriceLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:productpriceLabel];
        
        UIImageView *discountimageView = [[UIImageView alloc]initWithFrame:CGRectMake1(240, 65, 50, 20)];
        discountimageView.image = [UIImage imageNamed:@"band.png"];
        [self addSubview:discountimageView];
        
        discountLabel = [[UILabel alloc]initWithFrame:CGRectMake1(250, 65, 40, 20)];
        discountLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        discountLabel.textColor = [UIColor whiteColor];
        discountLabel.textAlignment = 1;
        [self addSubview:discountLabel];

        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake1(247, 91, 15, 15)];
        imageView1.image = [UIImage imageNamed:@"shoppingCart"];
        [self addSubview:imageView1];
        
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.frame = CGRectMake1(265, 90, 60, 20);
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_buyButton];
        
        collectimageView = [[UIImageView alloc]initWithFrame:CGRectMake1(340, 91, 15, 15)];
        [self addSubview:collectimageView];
        
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.frame = CGRectMake1(357, 90 , 50, 20);
        _collectButton.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        _collectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_collectButton];
        
    }
    return self;
}

-(NSString*)discountWithmarketPrice:(NSString*)marketPrice
                   WithproductPrice:(NSString*)productPrice
{
    CGFloat discount = [marketPrice floatValue]/[productPrice floatValue]*10;
    if (![productPrice isEqualToString:@"0.00"]) {
        NSString *str = [NSString stringWithFormat:@"%.1f折",discount];
        return str;
    }else
    {
        return @"0折";
    }
}

-(void)collectBtnAction:(UIButton *)btn
{
    if ([self.delegate collectAction:btn]) {
        if ([_collectButton.titleLabel.text isEqualToString:@"收藏"]) {
            collectimageView.image = [UIImage imageNamed:@"isCollection-YES"];
        }else
        {
            collectimageView.image = [UIImage imageNamed:@"isCollection-NO"];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
