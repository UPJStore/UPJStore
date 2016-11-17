//
//  ShopExpandTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/10/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShopExpandTableViewCell.h"
#import "UIViewController+CG.h"

@implementation ShopExpandTableViewCell
{
    UILabel* orderlabel;
    UILabel* namelabel;
    UILabel* timelabel;
    UILabel* statuslabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 30)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 30, 414, 60)];
        backView2.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
        [self addSubview:backView2];
        
        orderlabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 250, 30)];
        orderlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:orderlabel];
        
        namelabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 30, 150, 30)];
        namelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(11)];
        namelabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        [self addSubview:namelabel];
        
        timelabel = [[UILabel alloc]initWithFrame:CGRectMake1(180, 30, 150, 30)];
        timelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(11)];
        timelabel.textColor = [UIColor colorFromHexRGB:@"999999"];
        [self addSubview:timelabel];
        
        statuslabel = [[UILabel alloc]initWithFrame:CGRectMake1(294, 0, 100, 30)];
        statuslabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        statuslabel.textAlignment = 2;
        [self addSubview:statuslabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 59.5, 414, 0.5)];
        lineView.backgroundColor = [UIColor colorFromHexRGB:@"aaaaaa"];
        [self addSubview:lineView];
    }
    return self;
}

-(void)setModel:(ShopExpandModel *)model
{
    orderlabel.text = [NSString stringWithFormat:@"交易单号:%@",model.order_sn];
    namelabel.text = [NSString stringWithFormat:@"端口拥有人:%@",model.nickname];
    timelabel.text = model.pass_time;
    switch (model.deposit_status.integerValue) {
        case 0:
            statuslabel.text = @"可申请";
            break;
        case 1:
            statuslabel.text = @"已申请";
            break;
        case 2:
            statuslabel.text = @"审核通过";
            break;
        case 3:
            statuslabel.text = @"审核不通过";
            break;
        default:
            break;
    }
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
