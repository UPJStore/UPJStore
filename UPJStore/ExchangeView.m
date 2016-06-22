//
//  ExchangeView.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/11.
//  Copyright © 2016年 UPJApp. All rights reserved.
//



#import "ExchangeView.h"
#import "UIViewController+CG.h"

#define widthSize 414.0/320

#define hightSize 736.0/568
@implementation ExchangeView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(instancetype)initWithFrame:(CGRect)frame picture:(NSString *)picture string1:(NSString *)string1 string2:(NSString *)string2
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setBorderWidth:1.0];
        [self.layer setCornerRadius:10.0];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:picture]];
        imageView.frame = CGRectMake1(13, 4, 130, 39);
        [self addSubview:imageView];
        
        UIView *lineView = [[UIView alloc]
                            initWithFrame:CGRectMake1(150, 0, 0.5,46)];
        UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        lineView.backgroundColor =fontcolor;
        [self addSubview:lineView];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(164,10,120, 12)];
        label1.text = string1;
        UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        label1.textColor = textcolor;
        label1.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake1(164,30, 91, 9)];
        label2.text = string2;
        label2.textColor = fontcolor;
        label2.font = [UIFont systemFontOfSize:CGFloatMakeY(9)];
        [self addSubview:label2];
    }
    return self;
}
@end
