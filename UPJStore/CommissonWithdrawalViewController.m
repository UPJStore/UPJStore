//
//  CommissonWithdrawalViewController.m
//  UPJStore
//
//  Created by upj on 16/9/20.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CommissonWithdrawalViewController.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"
#import "CommissonTableViewCell.h"

@interface CommissonWithdrawalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *drawalView;
@property(nonatomic,strong)UIView *redlineView;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation CommissonWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    if (_isFlag) {
        self.navigationItem.title = @"佣金明细";
    }else
    {
        self.navigationItem.title = @"利润明细";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    
    [self initWithHeaderView];
    
}

-(void)initWithHeaderView
{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 147)];
    _headerView.clipsToBounds = YES;
    [self.view addSubview:_headerView];
    
    UIImageView *bgimgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing1.jpg"]];
    bgimgView.frame = CGRectMake1(0, 0,414, 147);
    [_headerView addSubview:bgimgView];
    [_headerView sendSubviewToBack:bgimgView];
    
    UIImageView *photoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headerPhoto"]];
    photoView.frame = CGRectMake1(157, 10, 100, 100);
    photoView.layer.cornerRadius = CGFloatMakeY(45);
    [_headerView addSubview:photoView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(167, 20, 80, 80)];
    imageView.image = [UIImage imageWithData:[self returnImageData]];
    imageView.layer.cornerRadius = CGFloatMakeY(40);
    imageView.clipsToBounds = YES;
    [_headerView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 120, 414, 20)];
    titleLabel.textAlignment = 1;
    titleLabel.text = [self returnNickName];
    titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [_headerView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 146, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [_headerView addSubview:lineView];
    
    [self initWithBtnView];
}

-(void)initWithBtnView
{
    _drawalView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height+CGFloatMakeY(10), kWidth, CGFloatMakeY(100))];
    _drawalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_drawalView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [_headerView addSubview:lineView];
    
    UIImageView *Img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CK2"]];
    Img.frame = CGRectMake1(20, 12, 16, 16);
    [_drawalView addSubview:Img];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(45, 0, 120, 40)];
    if (_isFlag) {
        label.text = [NSString stringWithFormat:@"可提现佣金金额 ："];
    }else
    {
        label.text = [NSString stringWithFormat:@"可提现利润金额 ："];
    }
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    
    [_drawalView addSubview:label];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(165, 0, 100, 40)];
    moneyLabel.text = @"1234";
    moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    moneyLabel.textColor = [UIColor redColor];
    [_drawalView addSubview:moneyLabel];
    
    UIButton *drawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    drawalBtn.frame = CGRectMake1(344, 7, 50, 26);
    drawalBtn.layer.cornerRadius = CGFloatMakeY(5);
    drawalBtn.backgroundColor = [UIColor redColor];
    [drawalBtn setTitle:@"提现" forState:UIControlStateNormal];
    [drawalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    drawalBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_drawalView addSubview:drawalBtn];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(10, 39, 394, 1)];
    lineView2.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    [_drawalView addSubview:lineView2];
    
    NSArray *arr =@[@"未付款",@"已付款",@"已发货",@"已完成"];
    
    for (int i = 0; i<4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(414/4*i, 50, 414/4, 20)];
        label.textColor = [UIColor redColor];
        label.text = @"123";
        label.textAlignment =1;
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [_drawalView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake1(414/4*i, 70, 414/4, 30);
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_drawalView addSubview:btn];
    }
    
    _redlineView = [[UIView alloc]initWithFrame:CGRectMake1(26.5, 95, 47.5, 1.5)];
    _redlineView.backgroundColor = [UIColor redColor];
    [_drawalView addSubview:_redlineView];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake1(0, 99, 414, 1)];
    lineView3.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    
    [self initWithTableView];
}

-(void)initWithTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _drawalView.frame.origin.y+_drawalView.frame.size.height+CGFloatMakeY(10),kWidth,kHeight-(_drawalView.frame.origin.y+_drawalView.frame.size.height+CGFloatMakeY(10))-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[CommissonTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommissonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 10)];
    view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    return view;
}


-(void)tapAction:(UIButton*)btn
{
 
    [UIView animateWithDuration:0.35 animations:^{
        _redlineView.frame = CGRectMake1(26.5+(414/4*btn.tag), 95, 47.5, 1.5);
    }];
    
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.isShowTab =YES;
    [self hideTabBarWithTabState:self.isShowTab];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
