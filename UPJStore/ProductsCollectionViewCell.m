//
//  ProductsCollectionViewCell.m
//  UPJStore
//
//  Created by upj on 16/3/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ProductsCollectionViewCell.h"
#import "UIColor+HexRGB.h"
#import "AppDelegate.h"

@implementation ProductsCollectionViewCell
-(void)setModel:(ProductsModel *)model{
    _model = model;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.marketprice];
    self.title.text = model.title;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    
    if (self) {
//        self.productBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.productBtn.frame = CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height);
//        self.productBtn.layer.borderWidth = 1;
//        self.productBtn.layer.borderColor = [[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]CGColor];
//        self.productBtn.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.productBtn];
//        self.contentView.layer.borderWidth = 1;
//        self.contentView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        self.contentView.backgroundColor = [UIColor whiteColor];

        // 产品图
        self.productImg = [[UIImageView alloc]initWithFrame:CGRectMake1(5,5,self.bounds.size.width-10,110)];
        self.productImg.backgroundColor = [UIColor clearColor];
        self.productImg.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:self.productImg];
        
        // 产品介绍
        self.title = [[UILabel alloc]initWithFrame:CGRectMake1(0,130,self.bounds.size.width,50)];
        self.title.textColor = [UIColor blackColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.numberOfLines = 0;
        self.title.font = [UIFont systemFontOfSize:11*app.autoSizeScaleY];
        [self.contentView addSubview:self.title];
        
        // 价格
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake1(5,180,self.bounds.size.width,20)];
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.font = [UIFont systemFontOfSize:18*app.autoSizeScaleY];
        self.priceLabel.textColor = [UIColor colorFromHexRGB:@"cc2245"];
        [self.contentView addSubview:self.priceLabel];
        
        
        
    }
    return self;
}
CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    //先得到appdelegate
    AppDelegate *app= [UIApplication sharedApplication].delegate;
    
    CGRect rect;
    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
    rect.origin.x = x;//原点的X坐标的改变
    rect.origin.y = y*app.autoSizeScaleY;//原点的Y坐标的改变
    rect.size.width = width;//宽的改变
    rect.size.height = height*app.autoSizeScaleY;//高的改变
    return rect;
}
@end
