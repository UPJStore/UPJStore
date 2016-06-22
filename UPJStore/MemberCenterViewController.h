//
//  MemberCenterViewController.h
//  UPJStore
//
//  Created by 张靖佺 on 16/2/16.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginAciton;

@interface MemberCenterViewController : UIViewController

@property(nonatomic,strong)NSString *mid;

@property(nonatomic,assign)BOOL islogin;

@end
