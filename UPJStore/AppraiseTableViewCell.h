//
//  AppraiseTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/4/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appraiseModel.h"
@interface AppraiseTableViewCell : UITableViewCell
@property (nonatomic,strong) appraiseModel *model;

-(void)initWithModel;

@end
