//
//  ModifyTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/5/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyTableViewCell : UITableViewCell

@property(nonatomic)UILabel *titleLabel;

@property(nonatomic)UILabel *messageLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isArrow:(BOOL)isArrow;

@end
