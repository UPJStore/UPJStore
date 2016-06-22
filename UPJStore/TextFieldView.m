//
//  RegisterView.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/3.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "TextFieldView.h"

#import "UIViewController+CG.h"

@implementation TextFieldView
{
    UIImageView *textfieldImage;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame String:(NSString *)string picture:(NSString *)picture number:(NSInteger)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake1(20, 10, number-40, 50)];
        _textfield.borderStyle = UITextBorderStyleRoundedRect;
        _textfield.backgroundColor = [UIColor whiteColor];
        _textfield.placeholder = string;
        _textfield.delegate = self;
        _textfield.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        _textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      //  _textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [self addSubview:_textfield];
        if (picture != nil) {
            _textfield.leftView=[[UIView alloc]initWithFrame:CGRectMake1(0, 0, 40, 50)];
            _textfield.leftViewMode = UITextFieldViewModeAlways;
            textfieldImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:picture]];
        //    textfieldImage.contentMode = UIViewContentModeScaleAspectFit;
            textfieldImage.frame = CGRectMake1(10, 10, 30 , 30);
            [_textfield.leftView addSubview:textfieldImage];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textfield resignFirstResponder];
}

-(void)passwordHide
{
    [_textfield setSecureTextEntry:YES];
    
}

-(void)passwordShow
{
    [_textfield setSecureTextEntry:NO];
}

-(void)addRightView:(UISwitch *)iswitch
{
    _textfield.rightView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _textfield.rightViewMode = UITextFieldViewModeAlways;
    _textfield.rightView = iswitch;
}

@end
