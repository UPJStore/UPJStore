//
//  descriptionView.m
//  UPJStore
//
//  Created by upj on 16/3/30.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "descriptionView.h"
#import "UIViewController+CG.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexRGB.h"
#import "myUILabel.h"
#import "LineLabel.h"

@implementation descriptionView

-(instancetype)initWithFrame:(CGRect)frame withModel:(DetailModel *)model withfromDealer:(BOOL)isfromDealer
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 20, 414, 0.5)];
        lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [self addSubview:lineView];
        
        UIImageView *CountryimageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGFloatMakeX(12), CGFloatMakeY(30), CGFloatMakeY(25), CGFloatMakeY(25))];
        NSString *imageURL = [NSString stringWithFormat:kSImageUrl,model.img];
        CountryimageView.contentMode = UIViewContentModeScaleAspectFit;
        [CountryimageView sd_setImageWithURL:[NSURL URLWithString:imageURL]placeholderImage:[UIImage imageNamed:@"lbtP"]];
        [self addSubview:CountryimageView];
        
        UILabel *countryLabel = [[UILabel alloc]initWithFrame:CGRectMake(CountryimageView.frame.origin.x+CountryimageView.frame.size.width+CGFloatMakeX(5), CGFloatMakeY(32), CGFloatMakeX(300), CGFloatMakeY(25))];
        countryLabel.text = model.country;
        countryLabel.font = [UIFont fontWithName:@"ArialMT" size:CGFloatMakeY(18)];
        countryLabel.textColor = [UIColor colorFromHexRGB:@"0057ef"];
        [self addSubview:countryLabel];
        
        
        CGFloat titleLength = [model.title boundingRectWithSize:CGSizeMake(kWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(18)]} context:nil].size.height;
        myUILabel * titleLabel = [[myUILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(12),CountryimageView.frame.origin.y+CountryimageView.frame.size.height+CGFloatMakeY(8), CGFloatMakeX(414-24), titleLength)];
        titleLabel.text = model.title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.verticalAlignment = VerticalAlignmentTop;
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
        [self addSubview:titleLabel];
        
        if (!isfromDealer) {
        
        UILabel * marketPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(13),CGFloatMakeY(5)+titleLabel.frame.origin.y+titleLabel.frame.size.height, CGFloatMakeX(400), CGFloatMakeY(40))];
        marketPrice.font = [UIFont systemFontOfSize:CGFloatMakeY(24)];
        //        marketPrice.textAlignment = NSTextAlignmentRight;
        
        marketPrice.layer.borderColor = [[UIColor colorFromHexRGB:@"333333"]CGColor];
        
        UILabel * marPrice = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 350, 30)];
        marPrice.font = [UIFont systemFontOfSize:CGFloatMakeY(22)];
        NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@ |",model.marketprice]];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NSMakeRange(0, model.marketprice.length+4)];
        [aStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:CGFloatMakeY(22)] range:NSMakeRange(0, model.marketprice.length+3)];
        marPrice.attributedText= aStr;
        marPrice.frame = CGRectMake(0, 0, [[NSString stringWithFormat:@"¥ %@ |",model.marketprice] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:CGFloatMakeY(22)]}].width+1, CGFloatMakeY(30));
        
        
        [marketPrice addSubview:marPrice];
        
        LineLabel *productLabel = [[LineLabel alloc]initWithFrame:CGRectMake(marPrice.frame.origin.x+marPrice.frame.size.width, CGFloatMakeY(3), [[NSString stringWithFormat:@"¥ %@",model.productprice] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(18)]}].width, CGFloatMakeY(30))];
        productLabel.text =[NSString stringWithFormat:@"¥ %@",model.productprice];
        productLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
        productLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        productLabel.lineType = 2;
        [marketPrice addSubview:productLabel];
        
        [self addSubview:marketPrice];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, marketPrice.frame.origin.y+marketPrice.frame.size.height-CGFloatMakeY(5));
        }else
        {
            UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0,CGFloatMakeY(5)+titleLabel.frame.origin.y+titleLabel.frame.size.height, kWidth, CGFloatMakeY(50))];
            [self addSubview:priceView];
            
            UILabel * marketPrice = [[UILabel alloc]initWithFrame:CGRectMake1(20,0,87,30)];
            marketPrice.text = @"零售价 ：";
            marketPrice.font = [UIFont systemFontOfSize:CGFloatMakeY(20)];
            [priceView addSubview:marketPrice];
            
            UILabel *marketLabel = [[UILabel alloc]initWithFrame:CGRectMake1(107, 0, 70, 30)];
            marketLabel.text = [NSString stringWithFormat:@"¥%@",model.marketprice];
            marketLabel.textColor = [UIColor redColor];
            marketLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
            [priceView addSubview:marketLabel];
            
            UILabel* productPrice = [[UILabel alloc]initWithFrame:CGRectMake1(200, 0, 60, 30)];
            productPrice.text = @"市场价 ：";
            productPrice.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            [priceView addSubview:productPrice];
            
           LineLabel* productLabel = [[LineLabel alloc]initWithFrame:CGRectMake1(260, 0, 70, 30)];
            productLabel.text = [NSString stringWithFormat:@"¥%@",model.productprice];
            productLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            productLabel.lineType = 2;
            [priceView addSubview:productLabel];
            
            UILabel *ant1price = [[UILabel alloc]initWithFrame:CGRectMake1(20, 30, 85, 20)];
            ant1price.text = @"蚂蚁利润 ：";
            ant1price.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
            [priceView addSubview:ant1price];
            
            UILabel *ant1Label = [[UILabel alloc]initWithFrame:CGRectMake1(105, 30, 70, 20)];
            ant1Label.text = [NSString stringWithFormat:@"¥%@",model.start];
            ant1Label.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
            ant1Label.textColor = [UIColor redColor];
            [priceView addSubview:ant1Label];
            
            UILabel *ant2price = [[UILabel alloc]initWithFrame:CGRectMake1(200, 30, 105, 20)];
            ant2price.text = @"下级推广可获 ：";
            ant2price.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            [priceView addSubview:ant2price];
            
            UILabel *ant2Label = [[UILabel alloc]initWithFrame:CGRectMake1(305, 30, 70, 20)];
            ant2Label.text = [NSString stringWithFormat:@"¥%@",model.start1];
            ant2Label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            ant2Label.textColor = [UIColor redColor];
            [priceView addSubview:ant2Label];
            
            self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, priceView.frame.origin.y+priceView.frame.size.height);
        }
        
    }
    return self;
}

//-(void)MethodView:(UIView*)MethodView BorderColor:(UIColor *)color BorderWidth:(CGFloat )width
//{
//    
//    CALayer *SSBorder;
//    
//    SSBorder.borderColor = color.CGColor;
//    SSBorder.borderWidth = width;
//    
//    SSBorder.frame = CGRectMake(-width, MethodView.frame.size.height-width, MethodView.frame.size.width, width);
//    [MethodView.layer addSublayer:SSBorder];
//    
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
