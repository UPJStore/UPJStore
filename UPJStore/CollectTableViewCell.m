//
//  CollectTableViewCell.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/6.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CollectTableViewCell.h"
#import "UIView+cg.h"

@implementation CollectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        self.pictureView = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10, 90, 90)];
        [self.pictureView.layer setBorderWidth:0.5];
        [self.pictureView.layer setBorderColor:fontcolor.CGColor];
        [self.pictureView.layer setCornerRadius:5];
        [self addSubview:self.pictureView];
        
        self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 10, 274, 50)];
        self.titlelabel.numberOfLines = 0;
        self.titlelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
        [self addSubview:self.titlelabel];
        
        self.pricelabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 80, 114, 20)];
        self.pricelabel.textColor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        self.pricelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
        [self addSubview:self.pricelabel];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake1(0, 120, 414, 20)];
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
