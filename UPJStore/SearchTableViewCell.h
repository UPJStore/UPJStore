//
//  SearchTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/9/8.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import "ProductsModel.h"

@protocol btnAction;

@interface SearchTableViewCell : UITableViewCell

@property(nonatomic,weak)id <btnAction> delegate;

@property(nonatomic,strong)SearchModel *model1;

@property(nonatomic,strong)ProductsModel *model2;

@property(nonatomic,strong)UIButton *buyButton;

@property(nonatomic,strong)UIButton *collectButton;

@property(nonatomic)BOOL iscollect;

@end

@protocol btnAction <NSObject>

-(BOOL)collectAction:(UIButton*)btn;

@end
