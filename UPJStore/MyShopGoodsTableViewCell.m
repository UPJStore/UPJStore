//
//  MyShopGoodsTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/11/1.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyShopGoodsTableViewCell.h"
#import "myUILabel.h"
#import "LineLabel.h"
#import "UIViewController+CG.h"

@implementation MyShopGoodsTableViewCell
{
    UIImageView *imageView;
    UIImageView *countryView;
    myUILabel *titleLabel;
    UILabel *marketpriceLabel;
    LineLabel *productpriceLabel;
    UILabel *profitLabel;
    UILabel *profitnextLabel;
}

-(void)setModel:(ShopGoodsModel *)model
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.upinkji.com/resource/attachment/%@",model.thumb]] placeholderImage:[UIImage imageNamed:@"lbtP"]];
      [countryView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.upinkji.com/resource/attachment/%@",model.img]] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    titleLabel.text = model.title;
    marketpriceLabel.text = [NSString stringWithFormat:@"零售价：¥%@",model.marketprice];
    productpriceLabel.text = [NSString stringWithFormat:@"¥%@",model.productprice];
    profitLabel.text = [NSString stringWithFormat:@"蚂蚁利润：¥%@",model.profit];
    profitnextLabel.text = [NSString stringWithFormat:@"下级推广利润：%@",model.profit_next];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10, 80, 80)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        countryView = [[UIImageView alloc]initWithFrame:CGRectMake1(93, 10, 20, 20)];
        [self addSubview:countryView];
        
        titleLabel = [[myUILabel alloc]initWithFrame:CGRectMake1(116, 10, 291, 40)];
        [titleLabel setVerticalAlignment:VerticalAlignmentTop];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:titleLabel];
        
        marketpriceLabel = [[UILabel alloc]initWithFrame:CGRectMake1(95, 60, 105,15)];
        marketpriceLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:marketpriceLabel];
        
        productpriceLabel = [[LineLabel alloc]initWithFrame:CGRectMake1(205, 60, 60, 15)];
        productpriceLabel.lineType = LineTypeMiddle;
        productpriceLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(10)];
        [self addSubview:productpriceLabel];
        
        profitLabel = [[UILabel alloc]initWithFrame:CGRectMake1(95, 75, 105, 15)];
        profitLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        profitLabel.textColor = [UIColor redColor];
        [self addSubview:profitLabel];
        
        profitnextLabel = [[UILabel alloc]initWithFrame:CGRectMake1(205, 75, 100, 15)];
        profitnextLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(10)];
        profitnextLabel.textColor = [UIColor redColor];
        [self addSubview:profitnextLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
