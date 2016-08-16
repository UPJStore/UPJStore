//
//  descriptionView.m
//  UPJStore
//
//  Created by upj on 16/3/30.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "descriptionView.h"
#import "UIView+cg.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexRGB.h"
#import "myUILabel.h"
#import "LineLabel.h"




@implementation descriptionView

-(instancetype)initWithFrame:(CGRect)frame withModel:(detailModel *)model
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
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, marketPrice.frame.origin.y+marketPrice.frame.size.height);
        
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
