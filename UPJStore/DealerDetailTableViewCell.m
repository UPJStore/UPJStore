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

@implementation DealerDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 40)];
        orderView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
        [self addSubview:orderView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
        lineView1.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [orderView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 39, 414, 1)];
        lineView2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [orderView addSubview:lineView2];
        
        UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 280, 40)];
        orderLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        orderLabel.text = @"订单号：12016111111111111";
        [orderView addSubview:orderLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(320, 0, 74, 40)];
        moneyLabel.textColor = [UIColor redColor];
        moneyLabel.textAlignment = 2;
        moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        moneyLabel.text = @"+3.30元";
        [orderLabel addSubview:moneyLabel];
        
        _arr = @[@"123",@"123",@"123"];
        
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 40, 414, 40*(_arr.count+1)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        tableView.scrollEnabled = NO;
        tableView.bounces = NO;
       // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count+1;
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
    [cell addSubview:rightLabel];
    
    if (indexPath.row == 0) {
        nameLabel.text = @"时间";
        nameLabel.textColor = [UIColor colorFromHexRGB:@"babcbb"];
        rightLabel.text = @"已完成";
        rightLabel.textColor = [UIColor colorFromHexRGB:@"babcbb"];
    }else
    {
        nameLabel.text = @"产品名";
        nameLabel.textColor = [UIColor blackColor];
        rightLabel.text = @"+3.30元";
        rightLabel.textColor = [UIColor blackColor];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
