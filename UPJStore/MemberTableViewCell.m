//
//  MemberTableViewCell.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MemberTableViewCell.h"
#import "UIViewController+CG.h"
@implementation MemberTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake1(20, 20, 20, 20)];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(60, 20, 300, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        self.arrowView = [[UIImageView alloc]initWithFrame:CGRectMake1(370, 20, 30, 20)];
       // NSLog(@"%f",self.contentView.bounds.size.width);
        self.arrowView.image = [UIImage imageNamed:@"rightArrow"];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.arrowView];
    }
    return self;
}



- (void)awakeFromNib {
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
