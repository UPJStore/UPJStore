//
//  LoginViewController.h
//  UPJStore
//
//  Created by 张靖佺 on 16/2/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

@protocol login;

@interface LoginViewController : UIViewController

@property (nonatomic,assign) BOOL isFromDetail;

@property(nonatomic,weak)id <login>delegate;

@end

@protocol login <NSObject>

-(void)loginFinishWithmodel:(MemberModel*)model;

@end

