//
//  SettingViewController.h
//  UPJStore
//
//  Created by 邝健锋 on 16/4/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol logout;

@interface SettingViewController : UIViewController

@property(nonatomic,assign)id <logout>delegate;

@end

@protocol logout <NSObject>

-(void)midlogout;

@end
