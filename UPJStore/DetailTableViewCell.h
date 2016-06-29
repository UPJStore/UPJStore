//
//  DetialTableViewCell.h
//  HomePage-3
//
//  Created by upj on 16/6/29.
//  Copyright © 2016年 upj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "LineLabel.h"
#import "myUILabel.h"

@interface DetailTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)UIImageView *detailImg;
@property(nonatomic,strong)UILabel *detailtitleLabel;
@property(nonatomic,strong)UILabel *marketLabel;
@property(nonatomic,strong)LineLabel *productLabel;
@property(nonatomic,strong)myUILabel *desLabel;
@property(nonatomic,strong)UIButton *salesBtn;
@property(nonatomic,strong)ProductModel *model;

-(void)change;

@end
