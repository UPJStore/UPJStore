//
//  brandViewController.m
//  UPJStore
//
//  Created by upj on 16/4/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "brandViewController.h"
#import "AFNetWorking.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"
#import "SearchTableViewCell.h"
#import "ProductsModel.h"
#import "GoodSDetailViewController.h"
#import "LoginViewController.h"
#import "BookIngViewController.h"
#import "DetailModel.h"
#import "MJExtension.h"
#import "CollectModel.h"

@interface brandViewController ()<UITableViewDelegate,UITableViewDataSource,btnAction>

@property (nonatomic,assign) BOOL isFocus;
@property (nonatomic,strong) UITableView * goodsTableView;
@property (nonatomic,strong) NSMutableArray *goodsArr ;
@property (nonatomic,strong) UIAlertController * attentionBrand;
@property (nonatomic,strong)DetailModel *detailmodel;
@end

@implementation brandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self getData];
    NSString * isFocusStr = @"关注";
    for (NSDictionary * dic in [self returnAttention]) {
        
        if ([_dic[@"cid"] isEqualToString:dic[@"id"]]==YES) {
            _isFocus =YES;
            isFocusStr = @"已关注";
        }
        
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:isFocusStr style:UIBarButtonItemStylePlain target:self action:@selector(FocusBtn:)];
}

-(void)FocusBtn:(UIBarButtonItem *)barBtn
{
    if ([[self returnMid]isEqualToString:@"0"] || [self returnMid] == nil) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        if (self.loadingHud == nil ) {
            [self setMBHUD];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self AttentionBrand];
        }

    }
    
}

-(void)initGoodTableView
{
    _goodsTableView  = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0,k6PWidth , k6PHeight-60)];
    _goodsTableView.backgroundColor  = [UIColor whiteColor];
    _goodsTableView.delegate  = self;
    _goodsTableView.dataSource = self;
    [_goodsTableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"cell"];
    _goodsTableView.showsVerticalScrollIndicator = NO;
    _goodsTableView.showsHorizontalScrollIndicator = NO;
    _goodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_goodsTableView];
}

-(void)getData
{
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:_dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:kSBrandGoodUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // DLog(@"%@",responseObject);
        NSArray* arrr = responseObject;
        for (NSDictionary * dic in arrr) {
            ProductsModel *model = [[ProductsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.goodsid = [dic valueForKey:@"id"];
            [self.goodsArr addObject:model];
        }
        if (arrr.count != 0) {
            [self initGoodTableView];
            [self.goodsTableView reloadData];
        }else
        {
            UIAlertController* collectionGoods = [UIAlertController alertControllerWithTitle:nil message:@"暂无商品数据" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:collectionGoods animated:YES completion:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAVC:) userInfo:nil repeats:NO];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
  
}


-(void)AttentionBrand
{
    
    NSDictionary * dic =@{@"appkey":APPkey,@"bid":_dic[@"cid"],@"mid":[self returnMid]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    
    [manager POST:kSAttenTionBrandUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // DLog(@"%@",responseObject);
#pragma 更改状态；
        if (_isFocus == NO) {
            _isFocus =YES;
            self.navigationItem.rightBarButtonItem.title = @"已关注";
            
        }else
        {
            _isFocus = NO;
            self.navigationItem.rightBarButtonItem.title = @"关注";
        }
         [self.loadingHud hideAnimated:YES];

        self.loadingHud = nil;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        DLog(@"error : %@",error);
        
    }];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(120);
}

//每个分区有几个ITEM
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _goodsArr.count;
}

//每个ITEM显示什么样的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    ProductsModel *model = _goodsArr[indexPath.row];
    cell.model2 = model;
    cell.delegate = self;
    cell.iscollect = [self iscollectioned:model.goodsid];
    [cell.buyButton addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//判断方法
-(BOOL)iscollectioned:(NSString*)goodsid
{
    if ([self returnIsLogin])
    {
        for (CollectModel * model in [self returnCollect])
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

-(BOOL)collectAction:(UIButton *)btn
{
    if (![self returnIsLogin]) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
        return NO;
    }else
    {
        [self postCollectionData:btn];
        return YES;
    }
}

-(void)postCollectionData:(UIButton *)btn
{
    if (![self returnIsLogin]) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
    }else{
        
        NSDictionary * dic =@{@"appkey":APPkey,@"mid":[self returnMid],@"gid":[NSString stringWithFormat:@"%ld",(long)btn.tag]};
#pragma dic MD5
        
        NSDictionary * nDic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer  = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:kCollectionGoods parameters:nDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
          //  DLog(@"%@",responseObject);
            NSDictionary * errDic = responseObject;
            NSString * str = errDic[@"errmsg"];
            if ([btn.titleLabel.text isEqualToString:@"收藏"]) {
                [btn setTitle:@"已收藏" forState:UIControlStateNormal];
            }else
            {
                [btn setTitle:@"收藏" forState:UIControlStateNormal];
            }
            
            UIAlertController* collectionGoods = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:collectionGoods animated:YES completion:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAVC:) userInfo:nil repeats:NO];
            [self postcollect];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

-(void)postcollect
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    [manager POST:kCollectList parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        NSString *errcode = [NSString stringWithFormat:@"%@",number];
        if ([errcode isEqualToString:@"0"]) {
            NSArray *jsonArr = @[];
            [self setCollectwithCollect:jsonArr];
        }else{
            NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
            [self setCollectwithCollect:jsonArr];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)dismissAVC:(NSTimer *)timer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)buyNowAction:(UIButton *)btn
{
    if (![self returnIsLogin]) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
    }else
    {
        NSDictionary * dic = @{@"appkey":APPkey,@"id":[NSString stringWithFormat:@"%ld",(long)btn.tag]};
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager *manager = [self sharedManager];;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:kGoodDetailURL parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          //  DLog(@"%@",responseObject);
            _detailmodel = [DetailModel mj_objectWithKeyValues:responseObject];
            BookIngViewController * bVC = [[BookIngViewController alloc]init];
            [self.navigationController pushViewController:bVC animated:YES];
            bVC.modelDic = [_detailmodel mj_keyValues];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"failure%@",error);
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsModel * model = self.goodsArr[indexPath.row];
    GoodSDetailViewController * goodsVC = [[GoodSDetailViewController alloc]init];
    NSDictionary * dic = @{@"appkey":APPkey,@"id":model.goodsid};
    goodsVC.goodsDic = dic;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

-(NSMutableArray *)goodsArr
{
    if (_goodsArr == nil) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_isFromAtten) {
        self.isShowTab = YES;
        [self hideTabBarWithTabState:self.isShowTab];
    }
    else
    {
        self.isShowTab = NO;
        [self showTabBarWithTabState:self.isShowTab];
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
