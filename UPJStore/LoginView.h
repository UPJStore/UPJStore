//
//  LoginView.h
//  UPJStore
//
//  Created by 张靖佺 on 16/2/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapAciton;

@interface LoginView : UIView<UITextFieldDelegate>

@property(nonatomic,weak)id <TapAciton> delegate;

@end

@protocol TapAciton <NSObject>

-(void)tapAction:(UIButton*)button dic:(NSDictionary*)dic;


@end