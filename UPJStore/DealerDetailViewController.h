//
//  DealerDetailViewController.h
//  UPJStore
//
//  Created by upj on 16/9/28.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BranchModel.h"

@interface DealerDetailViewController : UIViewController

@property(nonatomic,strong)BranchModel* model;

@property(nonatomic,strong)NSString *level;

@property(nonatomic,strong)NSString *domain_level;

@end
