//
//  CollectTableViewCell.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/6.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CollectTableViewCell.h"
#import "UIViewController+CG.h"

@implementation CollectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        self.pictureView = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10, 80, 80)];
        [self.pictureView.layer setBorderWidth:0.5];
        [self.pictureView.layer setBorderColor:fontcolor.CGColor];
        [self.pictureView.layer setCornerRadius:5];
        [self addSubview:self.pictureView];
        
        self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake1(94, 10, 300, 40)];
        self.titlelabel.numberOfLines = 0;
        self.titlelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:self.titlelabel];
        
        self.pricelabel = [[UILabel alloc]initWithFrame:CGRectMake1(94, 60, 140, 20)];
        self.pricelabel.textColor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        self.pricelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:self.pricelabel];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake1(0, 100, 414, 10)];
        view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        [self addSubview:view];
    }
    return self;
}

-(void)getImageViewWithstr:(NSString*)str
{
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
    self.pictureView.image = image;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
