//
//  SelectTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/4/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "SelectTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@implementation SelectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       
        
        self.selectLogo = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0,30,30)];
        self.selectLogo.center = CGPointMake1(20,30);
        [self addSubview:self.selectLogo];
        
        self.payLabel = [[UILabel alloc]initWithFrame:CGRectMake1(40,15,150,30)];
        self.payLabel.textAlignment = NSTextAlignmentLeft;
        self.payLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        self.payLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        [self addSubview:self.payLabel];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame = CGRectMake1(414-50,20, 20, 20);
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [self addSubview:self.sureBtn];
        
    }
    return self;
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
