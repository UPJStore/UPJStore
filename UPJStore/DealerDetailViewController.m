//
//  DealerDetailViewController.m
//  UPJStore
//
//  Created by upj on 16/9/28.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "DealerDetailViewController.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"
#import "DealerDetailTableViewCell.h"

@interface DealerDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *storeView;
@end

@implementation DealerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.title = @"店铺详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self initWithStoreView];
    
}

-(void)initWithStoreView
{
    _storeView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 110)];
    _storeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_storeView];
    //头像
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(20, 15, 80, 80)];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.layer.cornerRadius = CGFloatMakeY(7);
    [_storeView addSubview:imageView];
    
    UILabel *nameLablel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 15, 300, 20)];
    nameLablel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    nameLablel.text = @"分店名:adfgadfgadfgaed的店铺";
    nameLablel.textColor = [UIColor blackColor];
    [_storeView addSubview:nameLablel];
    
    UILabel *WXnameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 35, 300, 20)];
    WXnameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    WXnameLabel.text = @"分店微信:sdgadsgasdfgadf";
    WXnameLabel.textColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_storeView addSubview:WXnameLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 55, 300, 20)];
    moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    moneyLabel.text = @"营业额:dsagasd";
    moneyLabel.textColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_storeView addSubview:moneyLabel];
    
    UILabel *recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 75, 300, 20)];
    recommendLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    recommendLabel.text = @"推荐人:MIMI";
    recommendLabel.textColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_storeView addSubview:recommendLabel];
    
    [self initWithTableView];
}

-(void)initWithTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,_storeView.frame.size.height, kWidth, kHeight-_storeView.frame.size.height-64) style:UITableViewStylePlain];
    [tableView registerClass:[DealerDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.backgroundColor  = [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [self.view addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(80)+CGFloatMakeY(40)*3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 10)];
    view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    return view;
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
