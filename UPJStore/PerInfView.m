//
//  PerInfView.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "PerInfView.h"
#import "UIViewController+CG.h"

#define widthSize 414.0/320

#define hightSize 736.0/568

@implementation PerInfView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *percolor = [UIColor colorWithRed:209.0/255 green:65.0/255 blue:94.0/255 alpha:1];
        /*
        _integralBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _integralBtn.frame =CGRectMake1(0, 0, 138, 68);
        _integralBtn.backgroundColor = percolor;
        [_integralBtn setTitle:@"我的饼干" forState:UIControlStateNormal];
        _integralBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [_integralBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _integralBtn.titleLabel.textAlignment = 1;
        _integralBtn.tag = 0;
        [_integralBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_integralBtn];
        */
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBtn.frame = CGRectMake1(0, 0, 207, 68);
        _collectBtn.backgroundColor = percolor;
        [_collectBtn setTitle:@"收藏的商品" forState:UIControlStateNormal];
        _collectBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        [_collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _collectBtn.titleLabel.textAlignment = 1;
        _collectBtn.tag = 1;
        [_collectBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_collectBtn];
        
        _concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _concernBtn.frame = CGRectMake1(207, 0, 207, 68);
        _concernBtn.backgroundColor = percolor;
        [_concernBtn setTitle:@"关注的品牌" forState:UIControlStateNormal];
        _concernBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        [_concernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _concernBtn.titleLabel.textAlignment = 1;
        _concernBtn.tag = 2;
        [_concernBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_concernBtn];

    //    for (int i = 0; i<2; i++) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake1(206.5, 17, 1, 31)];
            line.backgroundColor = [UIColor whiteColor];
            [self addSubview:line];
  //      }
    }
    return self;
}

-(void)pushAction:(UIButton*)btn
{
    [self.delegate perinfViewPush:btn.tag];
}

@end
