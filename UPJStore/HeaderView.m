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
#import "UIButton+WebCache.h"


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
        btn.frame = CGRectMake1(365, 20, 40, 40);
        [btn addTarget:self  action:@selector(set1Action:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *settingImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingicon"]];
        settingImage.frame = CGRectMake1(10, 10, 20, 20);
        [btn addSubview:settingImage];
        [self addSubview:btn];
        
        photoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headerPhoto"]];
        photoView.frame = CGRectMake1(157, 10, 100, 100);
        photoView.layer.cornerRadius = CGFloatMakeY(45);
        [self addSubview:photoView];
        
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageBtn.frame = CGRectMake1(167, 20, 80, 80);
        _imageBtn.layer.cornerRadius =CGFloatMakeY(40);
        _imageBtn.clipsToBounds = YES;
        [self addSubview:_imageBtn];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 120, 414, 20)];
        label.textAlignment =1;
        label.text = name;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:label];
        
        logoView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 26,156,70)];
        logoView.center = CGPointMake1(207, 60);
        logoView.image = [UIImage imageNamed:@"logo-3@3x"];
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:logoView];
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        loginBtn.frame = CGRectMake1(134,105, 65, 32.5);
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.titleLabel.textAlignment =1;
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        
        registerBtn.frame = CGRectMake1(215, 105, 65, 32.5);
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.textAlignment = 1;
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:loginBtn];
        [self addSubview:registerBtn];
        
        line = [[UIView alloc]initWithFrame:CGRectMake1(207, 108.5, 1, 26)];
        line.backgroundColor = [UIColor blackColor];
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
        photoView.hidden = NO;
        _imageBtn.hidden = NO;
        label.hidden = NO;
    }
    else
    {
        logoView.hidden = NO;
        registerBtn.hidden = NO;
        loginBtn.hidden = NO;
        line.hidden = NO;
        photoView.hidden = YES;
        _imageBtn.hidden = YES;
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
    photoView.hidden = NO;
    _imageBtn.hidden = NO;
    label.hidden = NO;
    
    if ([image isEqualToString:@"0"]) {
        [_imageBtn setImage:[UIImage imageNamed:@"geren"] forState:UIControlStateNormal];
    }else{
        NSURL *url = [NSURL URLWithString:image];
        [_imageBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"geren"]];
    }
    label.text = name;
}

-(void)logoutfinish
{
    logoView.hidden = NO;
    registerBtn.hidden = NO;
    loginBtn.hidden = NO;
    line.hidden = NO;
    photoView.hidden = YES;
    _imageBtn.hidden = YES;
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
        label.text = str;
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