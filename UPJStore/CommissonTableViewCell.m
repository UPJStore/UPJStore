//
//  CommissonTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/9/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CommissonTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@implementation CommissonTableViewCell
{
    UILabel *orderLabel;
    UILabel *moneyLabel;
    UILabel *timeLabel;
    UILabel *stateLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        orderLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 250, 30)];
        orderLabel.textColor = [UIColor blackColor];
        orderLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        orderLabel.backgroundColor = [UIColor redColor];
        [self addSubview:orderLabel];
        
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(294, 0, 100, 30)];
        moneyLabel.textColor = [UIColor blackColor];
        moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        moneyLabel.textAlignment = 2;
        moneyLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:moneyLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 30, 200, 30)];
        timeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        timeLabel.textColor = [UIColor colorFromHexRGB:@"dddddd"];
        timeLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:timeLabel];
        
        stateLabel = [[UILabel alloc]initWithFrame:CGRectMake1(294, 30, 100, 30)];
        stateLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        stateLabel.textColor = [UIColor colorFromHexRGB:@"dddddd"];
        stateLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:stateLabel];
    }
    return self;
}

-(void)setModel:(DrawalModel *)model
{
    
}

-(NSString *)timeWithcuo:(NSString*)cuo
{
    NSTimeInterval time=[cuo doubleValue];
    //+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [dateFormatter stringFromDate: detaildate];
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
