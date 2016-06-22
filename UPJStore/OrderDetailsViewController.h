//
//  OrderDetailsViewController.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderDetailsViewController : UIViewController

@property(nonatomic,strong)OrderModel* model;

@property(nonatomic,strong)NSString *mid;

@property(nonatomic)BOOL isEvaluate;

@end
