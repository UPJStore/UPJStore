//
//  NewAddressViewController.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tableViewReflash;

@interface NewAddressViewController : UIViewController

@property(nonatomic,weak)id <tableViewReflash>delegate;

@property(nonatomic,strong)NSString *mid;

@property(nonatomic,strong)NSString *aid;

@property(nonatomic)BOOL isedit;

@property(nonatomic,strong)NSString *editnameStr;

@property(nonatomic,strong)NSString *editphoneStr;

@property(nonatomic,strong)NSString *editidcardStr;

@property(nonatomic,strong)NSString *editprovinceStr;

@property(nonatomic,strong)NSString *editcityStr;

@property(nonatomic,strong)NSString *editareaStr;

@property(nonatomic,strong)NSString *editfulladdressStr;

@end

@protocol tableViewReflash <NSObject>

-(void)tableViewReflash;

@end
