//
//  CommissonTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/9/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommissionModel.h"

@interface CommissonTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)CommissionModel *model;
@property(nonatomic,strong)UITableView *goodstableView;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic)BOOL isFlag;

-(void)changewith:(BOOL)selected;

@end
