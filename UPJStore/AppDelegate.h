//
//  AppDelegate.h
//  UPJStore
//
//  Created by 张靖佺 on 16/2/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"
#import "AFNetWorking.h"

@protocol sendModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic,weak)id <sendModel>delegate;

@property (strong, nonatomic) UIWindow *window;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
#pragma mark -- WeiXinLogin
@property (nonatomic,strong) NSString *wxCode;
@property (nonatomic,strong) NSString *access_token;
@property (nonatomic,strong) NSString *openid;
@property (nonatomic,strong) NSString *unionid;

@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *headimgurl;

@end

@protocol sendModel <NSObject>

-(void)loginFinishWithmodel:(MemberModel *)model;

@end

