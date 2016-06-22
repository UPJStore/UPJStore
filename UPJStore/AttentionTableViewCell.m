//
//  AttentionTableViewCell.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/9.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AttentionTableViewCell.h"
#import "UIViewController+CG.h"
#import "AFNetworking.h"


@implementation AttentionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        self.pictureView = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10, 90, 90)];
        [self.pictureView.layer setBorderWidth:0.5];
        [self.pictureView.layer setBorderColor:fontcolor.CGColor];
        [self.pictureView.layer setCornerRadius:5];
        [self addSubview:self.pictureView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 10, 274, 50)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:self.titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake1(330, 90, 70, 20);
        [button.layer setBackgroundColor:btncolor.CGColor];
        [button.layer setCornerRadius:5];
        [button setTitle:@"取消关注" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:CGFloatMakeY(14)]];
        [self addSubview:button];
        
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

-(void)cancelAction:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"取消关注"]) {
        [btn setTitle:@"加关注" forState:UIControlStateNormal];
    }else
    {
        [btn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
     NSDictionary *dic = @{@"appkey":APPkey,@"mid":self.mid,@"bid":self.pid};
    [self.delegate AttentionCancelWithdic:dic];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
