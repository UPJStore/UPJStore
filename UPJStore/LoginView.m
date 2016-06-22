//
//  LoginView.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "LoginView.h"
#import "UIViewController+CG.h"
#import "TextFieldView.h"

#define widthSize 414.0/320

#define hightSize 736.0/568

@implementation LoginView
{
    TextFieldView *name;
    TextFieldView *password;
    UIButton * loginBtn;
    UIButton * registerBtn;
    UIButton* forgetBtn;
    UILabel *label;
    UIImageView *wechatImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)tapAction:(UIButton*)button ;
{
     NSDictionary *parameters = @{@"appkey":APPkey,@"uname":name.textfield.text,@"pwd":password.textfield.text};
    [self.delegate tapAction:button dic:parameters];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        UIColor *fontcolor2 = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        
        name = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 0, 414, 736) String:@"用户名/手机号" picture:@"membericon" number:414];
        [self addSubview:name];
        
        password = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 60, 414, 736) String:@"请输入密码" picture:@"code" number:414];
        password.textfield.secureTextEntry = YES;
        [self addSubview:password];
        
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake1(20, 130, 374, 50);
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:CGFloatMakeY(16)];
        loginBtn.backgroundColor = btncolor;
        loginBtn.tag = 0;
        [loginBtn.layer setCornerRadius:5.0];
        [loginBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginBtn];
        
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake1(20, 190, 30, 14);
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        registerBtn.tag = 1;
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [registerBtn setTitleColor:fontcolor forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerBtn];
        
        forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetBtn.frame = CGRectMake1(334, 190, 60, 14);
        forgetBtn.tag = 2;
        [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [forgetBtn setTitleColor:btncolor forState:UIControlStateNormal];
         [forgetBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetBtn];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake1(176, 258, 62, 26)];
        label.text = @"其他登录";
        label.textAlignment = 1;
        label.textColor = fontcolor2;
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        
        for (int i=0 ; i<2; i++)
        {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(238*i, 271, 176, 0.5)];
            lineView.backgroundColor = fontcolor;
            if([WXApi isWXAppInstalled]){
                [self addSubview:lineView];
            }
        }
        wechatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixin"]];
        
        UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatBtn setTag:8];
        wechatBtn.frame = CGRectMake1(181,297, 52, 52);
        [wechatBtn setBackgroundImage:wechatImage.image forState:UIControlStateNormal];
        [wechatBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        if([WXApi isWXAppInstalled]){
            [self addSubview:wechatBtn];
            [self addSubview:label];

        }else{
            // 隐藏
            wechatBtn.hidden = YES;
        }
    }
    return self;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [name resignFirstResponder];
    [password resignFirstResponder];
}


@end
