//
//  ShoppingCarTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"
#import "ChangeCountView.h"

@protocol ShoppingCarCellDelegate;

@interface ShoppingCarTableViewCell : UITableViewCell
@property (nonatomic,strong) ShoppingCarModel * model;
@property (nonatomic,assign) NSInteger choosedCount;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,weak) id<ShoppingCarCellDelegate>delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView;

+(CGFloat)getHeight;

@end

@protocol ShoppingCarCellDelegate <NSObject>

-(void)singleClick:(ShoppingCarModel *)models row:(NSInteger)row;

@end