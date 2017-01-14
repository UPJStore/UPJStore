//
//  HomePageTableViewCell.m
//  HomePage-3
//
//  Created by upj on 16/6/13.
//  Copyright © 2016年 upj. All rights reserved.
//

#import "HomePageTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"
#import "HomepageLabel.h"
#import "CollectModel.h"

@implementation HomePageTableViewCell
{
    UITableView *tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        HomepageLabel *label = [[HomepageLabel alloc]initWithFrame:CGRectMake1(0, 217.5, 414, 50)];
        
        
        [self addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 267, 414, 0.5)];
        lineView.backgroundColor = [UIColor colorFromHexRGB:@"dddddd"];
        [self addSubview:lineView];
        
        tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 267.5, 414, 120*_modelArr.count)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
       // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollEnabled =NO;
        [tableView registerClass:[ProductTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:tableView];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake1(0,267.5+120*_modelArr.count, 414, 40);
        [_button setTitle:@"更多好货点这里 more" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [self addSubview:_button];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"morearrow.png"]];
        imageView.frame = CGRectMake1(278, 10, 20, 20);
        [_button addSubview:imageView];
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(120);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell *cell = [[ProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ProductModel *model  = _modelArr[indexPath.row];
    cell.model = model;
    cell.iscollect = [self iscollectioned:model.productId];
    cell.delegate = self;
    [cell.buyButton addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableViewreflash
{
    tableView.frame = CGRectMake1(0, 267.5, 414, 120*_modelArr.count);
    _button.frame = CGRectMake1(0,267.5+120*_modelArr.count, 414, 40);
    [tableView reloadData];
}

//判断方法
-(BOOL)iscollectioned:(NSString*)goodsid
{
    if (self.islogin)
    {
        for (CollectModel * model in self.collectArr)
        {
            if ([goodsid isEqualToString:[model valueForKey:@"id"]]) {
                return YES;
            }
        }
        return NO;
    }else
    {
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *model  = _modelArr[indexPath.row];
    [self.deletage didselectAction:model.productId];
}

-(void)buyNowAction:(UIButton*)btn
{
    [self.deletage buyNowAction:btn];
}

-(BOOL)collectAction:(UIButton*)btn
{
    return [self.deletage collectNowAction:btn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
