//
//  ModifyTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/5/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ModifyTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@implementation ModifyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isArrow:(BOOL)isArrow
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 10, 100, 30)];
        self.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake1(185, 10, 200, 30)];
        self.messageLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        self.messageLabel.textAlignment = 2;
        self.messageLabel.textColor = [UIColor colorFromHexRGB:@"b9b9b9"];
        [self addSubview:self.messageLabel];
        
        if (isArrow) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightArrow"]];
            imageView.frame  = CGRectMake1(395, 17, 10, 16);
            [self addSubview:imageView];
           // self.messageLabel.frame = CGRectMake1(180, 10, 200, 30);
        }
    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
