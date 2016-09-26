//
//  HeaderView.h
//  UPJStore
//
//  Created by 张靖佺 on 16/2/25.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginAciton;

@interface HeaderView : UIView

@property(nonatomic,weak)id <LoginAciton> delegate;

@property(nonatomic,strong)UIButton *imageBtn;

-(instancetype)initWithFrame:(CGRect)frame withIsLogin:(BOOL)isLogin withname:(NSString*)name;

-(void)loginfinishwithimage:(NSString*)image
                       name:(NSString*)name;

-(void)logoutfinish;

-(void)update:(NSString *)str;

-(void)islogin:(BOOL)islogin;

@end

@protocol LoginAciton <NSObject>

-(void)loginAction:(UIButton*)button;

-(void)registerAction:(UIButton*)btn;

-(void)settingAction:(UIButton*)btn;


@end

