//
//  SelectTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/4/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "SelectTableViewCell.h"
#import "UIViewController+CG.h"

@implementation SelectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        
        self.selectLogo = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0,50,50)];
        self.selectLogo.center = CGPointMake1(40,50);
        [self addSubview:self.selectLogo];
        
        self.payLabel = [[UILabel alloc]initWithFrame:CGRectMake1(100,40,150,30)];
        self.payLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.payLabel];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame = CGRectMake1(414-50,40, 30, 30);
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
