//
//  DealerDetailTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/10/12.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "DealerDetailTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"
#import "BranchDetailModel.h"

@implementation DealerDetailTableViewCell
{
    UILabel *orderLabel;
    UILabel *moneyLabel;
    UITableView * _tableView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _arr = [NSArray new];
        UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 40)];
        orderView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
        [self addSubview:orderView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
        lineView1.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [orderView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 39, 414, 1)];
        lineView2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [orderView addSubview:lineView2];
        
        orderLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 280, 40)];
        orderLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [orderView addSubview:orderLabel];
        
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(320, 0, 74, 40)];
        moneyLabel.textColor = [UIColor redColor];
        moneyLabel.textAlignment = 2;
        moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [orderView addSubview:moneyLabel];
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count+1;
}

-(void)setArr:(NSArray *)arr
{
    _arr = arr;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 40, 414, 40*(_arr.count+1)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.scrollEnabled = NO;
    _tableView.bounces = NO;
    [self addSubview:_tableView];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 280, 40)];
    nameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [cell addSubview:nameLabel];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake1(320, 0, 74, 40)];
    rightLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    rightLabel.textAlignment = 2;
    [cell addSubview:rightLabel];
    
    if (_arr.count!=0) {
        if (indexPath.row == 0) {
            BranchDetailModel *model = _arr[indexPath.row];
            nameLabel.text = [NSString stringWithFormat:@"%@",[self timeWithcuo:model.createtime]];
            nameLabel.textColor = [UIColor colorFromHexRGB:@"b7b7bf"];
            rightLabel.text = [NSString stringWithFormat:@"%@",[self swicthforstatus:model.status]];
            rightLabel.textColor = [UIColor colorFromHexRGB:@"babcbb"];
        }else
        {
            BranchDetailModel *model = _arr[indexPath.row-1];
            nameLabel.text = [NSString stringWithFormat:@"%@",model.tittle];
            nameLabel.textColor = [UIColor blackColor];
            rightLabel.text = [NSString stringWithFormat:@"+%.2f元",model.income.floatValue];
            rightLabel.textColor = [UIColor blackColor];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 10)];
    view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    return view;
}

-(void)cellreloate
{
    orderLabel.text = [NSString stringWithFormat:@"订单号:%@",_ordersn];
    moneyLabel.text = [NSString stringWithFormat:@"+%.2f元",_allincome.floatValue];
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

-(NSString*)swicthforstatus:(NSString *)status
{
    NSString *sta;
    NSInteger i=status.integerValue;
    switch (i) {
        case
            0:
            sta = @"待付款";
            break;
        case
            1:
            sta = @"待发货";
            break;
        case
            2:
            sta = @"待收货";
            break;
        case
            3:
            sta = @"已完成";
            break;
        case 4:
            sta = @"已评论";
            break;
        default:
            break;
    }
    return sta;
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
