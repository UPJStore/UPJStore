//
//  CommissionDetailTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/11/12.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CommissionDetailTableViewCell.h"
#import "UIViewController+CG.h"

@implementation CommissionDetailTableViewCell
{
    UILabel *typeLabel;
    UILabel *moneyLabel;
    UILabel *timeLabel;
    UILabel *statusLabel;
}

-(void)setModel:(CommissionDetailModel *)model
{
    typeLabel.text = @"提现-微信";
    moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.money];
    timeLabel.text = [self timeWithcuo:model.carrytime];
    statusLabel.text = [self switchWithStr:model.status];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 30)];
        [self addSubview:detailView];
        
        UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake1(0, 30, 414, 30)];
        [self addSubview:statusView];
        
        typeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 200, 30)];
        typeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [detailView addSubview:typeLabel];
        
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(254, 0, 140, 30)];
        moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        moneyLabel.textAlignment = 2;
        [detailView addSubview:moneyLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 200, 30)];
        timeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        timeLabel.textColor = [UIColor colorFromHexRGB:@"babacbb"];
        [statusView addSubview:timeLabel];
        
        statusLabel = [[UILabel alloc]initWithFrame:CGRectMake1(254, 0, 140, 30)];
        statusLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        statusLabel.textColor = [UIColor colorFromHexRGB:@"babcbb"];
        statusLabel.textAlignment = 2;
        [statusView addSubview:statusLabel];
    }
    return self;
}


-(NSString *)timeWithcuo:(NSString*)cuo
{
    NSTimeInterval time=[cuo doubleValue];
    //+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate: detaildate];
}

-(NSString*)switchWithStr:(NSString*)str;
{
    NSString *status = [NSString new];
    NSInteger i = str.integerValue;
    switch (i) {
        case -2:
            status = @"已删除";
            break;
        case -1:
            status = @"审核无效";
            break;
        case 0:
            status = @"待审核";
            break;
        case 1:
            status = @"已审核";
            break;
        case 2:
            status = @"已完成";
            break;
        case 3:
            status = @"已完成";
            break;
        default:
            break;
    }
    return status;
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
