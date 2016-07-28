//
//  HomePageTableViewCell.h
//  HomePage-3
//
//  Created by upj on 16/6/13.
//  Copyright © 2016年 upj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductTableViewCell.h"
@protocol btnAction;

@interface HomePageTableViewCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate,collectAction>

@property(nonatomic,weak)id <btnAction>deletage;

@property(nonatomic,strong)NSArray *modelArr;

@property(nonatomic)BOOL islogin;

@property(nonatomic,strong)NSArray *collectArr;

@property(nonatomic,strong)UIButton *button;

-(void)tableViewreflash;

@end

@protocol btnAction <NSObject>

-(void)buyNowAction:(UIButton*)btn;

-(BOOL)collectNowAction:(UIButton*)btn;

-(void)didselectAction:(NSString*)pid;

@end
