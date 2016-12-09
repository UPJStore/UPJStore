//
//  ShopExpandViewController.m
//  UPJStore
//
//  Created by upj on 16/10/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShopExpandViewController.h"
#import "UIViewController+CG.h"
#import "ShopExpandTableViewCell.h"
#import "ShopExpandModel.h"

@interface ShopExpandViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView* headerView;
@property(nonatomic,strong)UIView* detailView;
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *numberlabel1;
@property(nonatomic,strong)UILabel *numberlabel2;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *tableArr;
@property(nonatomic,strong)NSString *ids;
@property(nonatomic,strong)NSString *interface_money;
@property(nonatomic,strong)NSString *use_interface;
@property(nonatomic,strong)NSString *used_interface;
@end

@implementation ShopExpandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   self.view.backgroundColor =[UIColor colorFromHexRGB:@"f6f6f6"];
    self.navigationItem.title = @"蚁店推广";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    [self postdataWithData];
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
    
    [self initWithDetailView];
}

-(void)initWithDetailView
{
    _detailView = [[UIView alloc]initWithFrame:CGRectMake1(0, 157,414, 515)];
    _detailView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    [self.view addSubview:_detailView];
    
    UIView *numberView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 30)];
    numberView.backgroundColor = [UIColor whiteColor];
    [_detailView addSubview:numberView];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake1(5, 5, 15, 15)];
    [_detailView addSubview:_logoView];
    
    _numberlabel1 = [[UILabel alloc]initWithFrame:CGRectMake1(25, 0, 200, 30)];
    _numberlabel1.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    _numberlabel1.text = [NSString stringWithFormat:@"蚂蚁经纪人: %@个",_used_interface];
    _numberlabel1.textAlignment = 0;
    [_detailView addSubview:_numberlabel1];
    
    _numberlabel2 = [[UILabel alloc]initWithFrame:CGRectMake1(250, 0, 144, 30)];
    _numberlabel2.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    _numberlabel2.text = [NSString stringWithFormat:@"免费端口剩余数: %@个",_use_interface];
    _numberlabel2.textAlignment = 2;
    [_detailView addSubview:_numberlabel2];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 40, 414, 475) style:UITableViewStylePlain];
    [_tableView registerClass:[ShopExpandTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"none"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_detailView addSubview:_tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _tableArr.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none" forIndexPath:indexPath];
        UILabel *noneView = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 30)];
        noneView.text = @"没有更多交易单号了!";
        noneView.textAlignment = 1;
        noneView.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [cell addSubview:noneView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        ShopExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        ShopExpandModel *model = _tableArr[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArr.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGFloatMakeY(90);
}

//
-(void)postdataWithData
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"page":@"1",@"pcount":@"10"};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KGetInterfaceCenter parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *arr = [NSArray arrayWithArray:responseObject];
        NSMutableArray *arr1 = [NSMutableArray new];
        for (NSDictionary *dic  in arr) {
            ShopExpandModel *model = [ShopExpandModel new];
            [model setValuesForKeysWithDictionary:dic];
            [arr1 addObject:model];
        }
        _tableArr = [NSArray arrayWithArray:arr1];
        [self postdataWithData2];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postdataWithData];
    }];
}

-(void)postdataWithData2
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KSumInterface parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        _ids = dic[@"ids"];
        _interface_money = dic[@"interface_money"];
        _use_interface = dic[@"use_interface"];
        _used_interface = dic[@"used_interface"];
        [self initWithHeaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        
    }];
}

-(void)postdataWithData3
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"ids":_ids};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KUpdateTakeMoney parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self initWithHeaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)postdataWithData4
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KGetCanGetList parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self initWithHeaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
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
