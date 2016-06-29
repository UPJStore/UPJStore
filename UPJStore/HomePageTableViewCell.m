//
//  HomePageTableViewCell.m
//  HomePage-3
//
//  Created by upj on 16/6/13.
//  Copyright © 2016年 upj. All rights reserved.
//

#import "HomePageTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 40)];
        self.titleLabel.textAlignment = 1;
        self.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        
        self.footView = [[UIView alloc]init];
        self.footView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
        [self addSubview:self.titleLabel];
        [self addSubview:self.footView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
