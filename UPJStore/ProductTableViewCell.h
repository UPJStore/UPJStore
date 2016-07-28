//
//  ProductTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/7/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@protocol collectAction;

@interface ProductTableViewCell : UITableViewCell

@property(nonatomic,weak)id <collectAction>delegate;

@property(nonatomic,strong)ProductModel *model;

@property(nonatomic,strong)UIButton *buyButton;

@property(nonatomic,strong)UIButton *collectButton;

@property(nonatomic)BOOL iscollect;

@end

@protocol collectAction <NSObject>

-(BOOL)collectAction:(UIButton*)btn;

@end

