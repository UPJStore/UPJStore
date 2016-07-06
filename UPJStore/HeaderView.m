//
//  HeaderView.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/25.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "HeaderView.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+CG.h"


#define widthSize 414.0/320
#define hightSize 736.0/568

@interface HeaderView ()
{
    UIImageView * logoView;
    UIImageView * photoView;
    UIButton * loginBtn;
    UIButton * registerBtn;
    UIButton * nameBtn;
    UIImageView * settingLogo;
    UIView* line;
    UILabel *label;
}

@end

@implementation HeaderView


-(instancetype)initWithFrame:(CGRect)frame withIsLogin:(BOOL)isLogin withname:(NSString*)name
{
    
    if (self = [super initWithFrame:frame]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake1(355, 30, 40, 40);
        [btn addTarget:self  action:@selector(set1Action:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"settingicon"] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake1(167, 50, 80, 80);
        _imageView.layer.cornerRadius =CGFloatMakeY(40);
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 146, 414, 20)];
        label.textAlignment =1;
        label.text = [NSString stringWithFormat:@"%@,欢迎你回来",name];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        [self addSubview:label];
        
        logoView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 26,156,70)];
        logoView.center = CGPointMake1(207, 78);
        logoView.image = [UIImage imageNamed:@"logo-3@3x"];
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:logoView];
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        loginBtn.frame = CGRectMake1(129,130, 65, 32.5);
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.textAlignment =1;
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        
        registerBtn.frame = CGRectMake1(220, 130, 65, 32.5);
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        registerBtn.titleLabel.textAlignment = 1;
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
        [registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:loginBtn];
        [self addSubview:registerBtn];
        
        line = [[UIView alloc]initWithFrame:CGRectMake1(207, 136.5, 1, 26)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
        [self islogin:isLogin];
    }
    return self;
}

-(void)islogin:(BOOL)islogin
{
    if (islogin)
    {
        logoView.hidden = YES;
        registerBtn.hidden = YES;
        loginBtn.hidden = YES;
        line.hidden = YES;
        _imageView.hidden = NO;
        label.hidden = NO;
    }
    else
    {
        logoView.hidden = NO;
        registerBtn.hidden = NO;
        loginBtn.hidden = NO;
        line.hidden = NO;
        _imageView.hidden = YES;
        label.hidden = YES;
    }
    
}

-(void)loginfinishwithimage:(NSString*)image
                       name:(NSString*)name
{
    logoView.hidden = YES;
    registerBtn.hidden = YES;
    loginBtn.hidden = YES;
    line.hidden = YES;
    _imageView.hidden = NO;
    label.hidden = NO;
    
    if ([image isEqualToString:@"0"]) {
        _imageView.image = [UIImage imageNamed:@"geren@3x"];
    }else{
        NSURL *url = [NSURL URLWithString:image];
        [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"geren@3x"]];
    }
    label.text = [NSString stringWithFormat:@"%@,欢迎你回来",name];
}

-(void)logoutfinish
{
    logoView.hidden = NO;
    registerBtn.hidden = NO;
    loginBtn.hidden = NO;
    line.hidden = NO;
    _imageView.hidden = YES;
    label.hidden = YES;
}


-(void)set1Action:(UIButton*)button
{
    [self.delegate settingAction:button];
}

-(void)loginAction:(UIButton*)button
{
    [self.delegate loginAction:button];
}

-(void)registerAction:(UIButton*)btn
{
    [self.delegate registerAction:btn];
}

-(void)update:(NSString *)str
{
    if([str isEqualToString:@"0"])
    {
        label.text = @"未设置昵称";
    }else
    {
        label.text = [NSString stringWithFormat:@"%@,欢迎你回来",str];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end