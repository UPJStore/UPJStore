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
        
    
        UILabel * marketPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(9),CGFloatMakeY(10), CGFloatMakeX(400), CGFloatMakeY(40))];
        marketPrice.font = [UIFont systemFontOfSize:CGFloatMakeY(24)];
        //        marketPrice.textAlignment = NSTextAlignmentRight;

        marketPrice.layer.borderColor = [[UIColor colorFromHexRGB:@"333333"]CGColor];
        
        UILabel * marPrice = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 350, 30)];
//        marPrice.textAlignment = NSTextAlignmentCenter;
        marPrice.font = [UIFont systemFontOfSize:CGFloatMakeY(24)];
        NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@ |",model.marketprice]];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"cc2245"]  range:NSMakeRange(0, model.marketprice.length+4)];
        [aStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:CGFloatMakeY(24)] range:NSMakeRange(0, model.marketprice.length+3)];
        marPrice.attributedText= aStr;
        marPrice.frame = CGRectMake(0, 0, [[NSString stringWithFormat:@"¥ %@ |",model.marketprice] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:CGFloatMakeY(24)]}].width+1, CGFloatMakeY(30));
        
        
        [marketPrice addSubview:marPrice];
        
        LineLabel *productLabel = [[LineLabel alloc]initWithFrame:CGRectMake(marPrice.frame.origin.x+marPrice.frame.size.width, 0, [[NSString stringWithFormat:@"¥ %@",model.productprice] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(14)]}].width, CGFloatMakeY(30))];
        productLabel.text =[NSString stringWithFormat:@"¥ %@",model.productprice];
        productLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        productLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        productLabel.lineType = 2;
        [marketPrice addSubview:productLabel];
        
        [self addSubview:marketPrice];
        
        
        
        
        UIImageView *CountryimageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGFloatMakeY(9), marketPrice.frame.origin.y+CGFloatMakeY(45), CGFloatMakeY(18), CGFloatMakeY(18))];
        NSString *imageURL = [NSString stringWithFormat:kSImageUrl,model.img];
        CountryimageView.contentMode = UIViewContentModeScaleAspectFit;
        [CountryimageView sd_setImageWithURL:[NSURL URLWithString:imageURL]placeholderImage:[UIImage imageNamed:@"lbtP"]];
        [self addSubview:CountryimageView];
        
        
        CGFloat titleLength = [model.title boundingRectWithSize:CGSizeMake(kWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(17)]} context:nil].size.height + CGFloatMakeY(17) +5;
        myUILabel * titleLabel = [[myUILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(36),marketPrice.frame.origin.y+CGFloatMakeY(45), CGFloatMakeX(414-54), titleLength)];
        titleLabel.text = model.title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.verticalAlignment = VerticalAlignmentTop;
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(17)];
        [self addSubview:titleLabel];
        
        NSString *desStr;
        if (model.detailDescription.length == 0) {
            desStr = @"该商品暂时缺乏描述~敬请期待哟。";
        }else
        {
            desStr = model.detailDescription;
        }
        
        CGFloat DesLength;
        if ([desStr rangeOfString:@"\n"].location == NSNotFound)
        {
           DesLength  = [desStr boundingRectWithSize:CGSizeMake(kWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(14)]} context:nil].size.height +CGFloatMakeY(14)+5;

        }
        else
        {
            DesLength = [desStr boundingRectWithSize:CGSizeMake(kWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(14)]} context:nil].size.height +CGFloatMakeY(14)*3;
        
        }
        
        
        UILabel * desLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(36), titleLabel.frame.origin.y+CGFloatMakeY(10)+titleLength, CGFloatMakeY(414-45), DesLength)];
        desLabel.numberOfLines = 0;
        desLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
        desLabel.text = desStr;
//        desLabel.textColor = [UIColor colorFromHexRGB:@"000000"];
        desLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:desLabel];
        
   
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, desLabel.frame.origin.y+CGFloatMakeY(39)+DesLength);
//        self.layer.borderWidth = 0.6;
        
        
        #pragma 下边线
        CALayer* layer = [self layer];
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.borderColor = [UIColor colorFromHexRGB:@"d9d9d9"].CGColor;
        bottomBorder.borderWidth = 0.6;
        bottomBorder.frame = CGRectMake(-0.6, layer.frame.size.height-0.6, layer.frame.size.width, 0.6);
        [layer addSublayer:bottomBorder];
        
        CALayer *markLayer = [marketPrice layer];
        CALayer *SSBorder = [CALayer layer];
        SSBorder.borderColor = [UIColor colorFromHexRGB:@"d9d9d9"].CGColor;
        SSBorder.borderWidth = 0.6;
        SSBorder.frame = CGRectMake(-0.6, markLayer.frame.size.height-0.6, markLayer.frame.size.width, 0.6);
        [markLayer addSublayer:SSBorder];
        
        
//        self.layer.borderColor = [[UIColor colorFromHexRGB:@"333333"]CGColor];

        
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
