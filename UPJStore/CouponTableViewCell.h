//
//  CouponTableViewCell.h
//  UPJStore
//
//  Created by 邝健锋 on 16/5/4.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)UILabel *moneyLabel;

@property (nonatomic,strong) UILabel *label1;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier FromCoupon:(BOOL)isFrom;

@end
