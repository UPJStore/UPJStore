//
//  BranchTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/11/3.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "BranchTableViewCell.h"
#import "UIViewController+CG.h"

@implementation BranchTableViewCell
{
    UIImageView *avatarView;
    UILabel *shopnameLabel;
    UILabel *incomeLabel;
    UILabel *wxnameLabel;
    UILabel *tuiLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        avatarView = [[UIImageView alloc]initWithFrame:CGRectMake1(20, 20, 80, 80)];
        avatarView.layer.cornerRadius = CGFloatMakeY(5);
        avatarView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:avatarView];
        
        shopnameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 20, 270, 20)];
        shopnameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self.contentView addSubview:shopnameLabel];
        
        wxnameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 40, 270, 20)];
        wxnameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self.contentView addSubview:wxnameLabel];
        
        incomeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 60, 270, 20)];
        incomeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self.contentView addSubview:incomeLabel];
        
        tuiLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 80, 270, 20)];
        tuiLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self.contentView addSubview:tuiLabel];
    }
    return self;
}

-(void)setModel:(BranchModel *)model
{
    [avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    shopnameLabel.text = [NSString stringWithFormat:@"分店名:%@",model.shop_name];
    wxnameLabel.text = [NSString stringWithFormat:@"分店微信:%@",model.nickname];
    incomeLabel.text = [NSString stringWithFormat:@"营业额:%@",model.income];
    tuiLabel.text = [NSString stringWithFormat:@"推荐人:%@",model.tui];
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
