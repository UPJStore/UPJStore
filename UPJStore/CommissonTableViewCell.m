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
    UIView *backView;
    UILabel *timeLabel;
    UILabel *statusLabel;
    NSString *str;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        orderLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 270, 30)];
        orderLabel.textColor = [UIColor blackColor];
        orderLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    //    orderLabel.backgroundColor = [UIColor redColor];
        [self addSubview:orderLabel];
        
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(314, 0, 80, 30)];
        moneyLabel.textColor = [UIColor blackColor];
        moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        moneyLabel.textAlignment = 2;
      //  moneyLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:moneyLabel];
        
        _goodstableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 30, 414, 30*_arr.count) style:UITableViewStylePlain];
        _goodstableView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
        _goodstableView.delegate = self;
        _goodstableView.dataSource = self;
        _goodstableView.showsVerticalScrollIndicator = NO;
        _goodstableView.showsHorizontalScrollIndicator = NO;
        _goodstableView.scrollEnabled = NO;
        [_goodstableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:_goodstableView];
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, _goodstableView.frame.size.height+CGFloatMakeY(30), kWidth,CGFloatMakeY(30))];
        backView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
        [self addSubview:backView];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 200, 30)];
        timeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        timeLabel.textColor = [UIColor colorFromHexRGB:@"babcbb"];
     //   timeLabel.backgroundColor = [UIColor blueColor];
        [backView addSubview:timeLabel];
        
        statusLabel = [[UILabel alloc]initWithFrame:CGRectMake1(294, 0, 100, 30)];
        statusLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        statusLabel.textColor = [UIColor colorFromHexRGB:@"babcbb"];
        statusLabel.textAlignment = 2;
      //  statusLabel.backgroundColor = [UIColor yellowColor];
        [backView addSubview:statusLabel];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(30);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 280, 30)];
    label1.text = [NSString stringWithFormat:@"%@ X%@",_arr[indexPath.row][@"title"],_arr[indexPath.row][@"total"]];
    label1.textColor = [UIColor colorFromHexRGB:@"babcbb"];
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(11)];
    [cell addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake1(324, 0, 70, 30)];
    label2.text = [NSString stringWithFormat:@"+%@元",_arr[indexPath.row][str]];
    label2.textColor = [UIColor colorFromHexRGB:@"babcbb"];
    label2.textAlignment = 2;
    label2.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [cell addSubview:label2];
    
    cell.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)setModel:(CommissionModel *)model
{
    if(_isFlag){
        moneyLabel.text = [NSString stringWithFormat:@"+%@元",model.ncommission];
    }else
    {
        moneyLabel.text = [NSString stringWithFormat:@"+%@元",model.commission];
    }
    if ([model.level isEqualToString:@"1"]) {
        orderLabel.text = [NSString stringWithFormat:@"1级订单:%@",model.ordersn];
    }else if([model.level isEqualToString:@"2"])
    {
        orderLabel.text = [NSString stringWithFormat:@"2级订单:%@",model.ordersn];
    }else if([model.level isEqualToString:@"3"])
    {
        orderLabel.text = [NSString stringWithFormat:@"3级订单:%@",model.ordersn];
    }
    timeLabel.text = model.createtime;
    switch ([model.status integerValue]) {
        case 0:
        {
            statusLabel.text = @"未付款";
        }
            break;
        case 1:
        {
            statusLabel.text = @"已付款";
        }
            break;
        case 2:
        {
            statusLabel.text = @"已发货";
        }
            break;
        case 3:
        {
            statusLabel.text = @"已完成";
        }
            break;
        default:
        {
            statusLabel.text = @"已完成";
        }
            break;
    }
    switch ([model.level integerValue]) {
        case 1:
            str = @"commission";
            break;
        case 2:
            str = @"commission2";
            break;
        case 3:
            str = @"commission3";
            break;
        default:
            break;
    }
}

-(void)changewith:(BOOL)selected
{
    [UIView animateWithDuration:0.3 animations:^{
    if (selected) {
        _goodstableView.frame = CGRectMake1(0, 30, 414, 30*_arr.count);
        [_goodstableView reloadData];
    }else
    {
        _goodstableView.frame = CGRectMake1(0, 30, 414, 0);
    }
    backView.frame = CGRectMake(0, _goodstableView.frame.size.height+CGFloatMakeY(30), kWidth,CGFloatMakeY(30));
    }];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
