//
//  RegisterView.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/3.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameRegisteredViewController.h"

@interface TextFieldView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textfield;;

-(instancetype)initWithFrame:(CGRect)frame
                      String:(NSString*)string
                     picture:(NSString*)picture
                      number:(NSInteger)number;

-(void)passwordHide;

-(void)passwordShow;

-(void)addRightView:(UISwitch*)iswitch;

@end

