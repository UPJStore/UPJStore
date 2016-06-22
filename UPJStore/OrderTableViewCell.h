//
//  OrderTableViewCell.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *statelabel;

@property(nonatomic,strong)UIButton *button1;

@property(nonatomic,strong)UIButton *button2;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(OrderModel*)model isEvaluate:(BOOL)isEvaluate;

-(void)buttonGetStrWithbutton1:(NSString*)str1 button2:(NSString*)str2;

@end
