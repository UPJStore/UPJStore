//
//  GoodsViewController.m
//  UPJStore
//
//  Created by upj on 16/3/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "GoodsViewController.h"
#import "ProductsModel.h"
#import "ProductsCollectionViewCell.h"
#import "UIViewController+CG.h"
#import "XLPlainFlowLayout.h"
#import "GoodSDetailViewController.h"
#import "SearchTableViewCell.h"
#import "LoginViewController.h"
#import "CollectModel.h"
#import "DetailModel.h"
#import "MJExtension.h"
#import "BookIngViewController.h"

@interface GoodsViewController ()<UITableViewDelegate,UITableViewDataSource,btnAction>

@property (nonatomic,strong)UITableView *goodsTableView;
@property (nonatomic,strong)NSMutableArray *goodsArr;
@property (nonatomic,strong)DetailModel *detailmodel;
@property (nonatomic,strong)NSArray *btnArr;
@property (nonatomic,strong) NSArray * arr;
@property (nonatomic,assign) BOOL isUp;

@end

@implementation GoodsViewController
-(NSMutableArray *)goodsArr{
    if (!_goodsArr) {
        self.goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}
-(NSArray *)btnArr{
    if (!_btnArr) {
        self.goodsArr = [NSMutableArray array];
    }
    return _btnArr;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self showTabBarWithTabState:self.isShowTab];
    self.navigationItem.title = @"商品";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    [self getData];
    
    // Do any additional setup after loading the view.
}

-(void)initTableView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    _arr = @[@"最新",@"人气",@"销量",@"价格",@"价格▲",@"价格▼"];
    for(int i = 0; i<4;i++)
    {
        
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            [btn setSelected:YES];
            [self isFromWhat:1000];
        }
        btn.frame = CGRectMake1(i*k6PWidth/4, 0, k6PWidth/4, 40);
        btn.tag = 1000+i;
        [btn setTitle:_arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [btn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [[UIColor blackColor]CGColor];
        [headerView addSubview:btn];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 39.5, 414, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [self.view addSubview:lineView];
    
    self.goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 40, 414, k6PHeight-104)];
    self.goodsTableView.delegate = self;
    self.goodsTableView.dataSource = self;
    self.goodsTableView.showsVerticalScrollIndicator = NO;
    self.goodsTableView.showsHorizontalScrollIndicator = NO;
    _goodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_goodsTableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_goodsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"header"];
    
    
    [self.view addSubview:self.goodsTableView];
    
}
-(void)pop{
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{
    
    NSDictionary * dic =@{@"appkey":APPkey,@"pid":[self pid]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:ProductURL parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *arr = responseObject;
        for (NSDictionary *dic in arr ) {
            ProductsModel *model = [[ProductsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.goodsid = [dic valueForKey:@"id"];
            [self.goodsArr addObject:model];
        }
        [self initTableView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFromSort) {
        if (indexPath.row == 0) {
            return CGFloatMakeY(150*414/330);
        }else
        {
            return CGFloatMakeY(120);
        }
    }else
    {
        return CGFloatMakeY(120);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFromSort) {
        return _goodsArr.count+1;
    }else
    {
        return _goodsArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFromSort) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 414, 150*414/330)];
            imageView.image = _headerImg;
            [cell addSubview:imageView];
            return cell;
        }else
        {
            ProductsModel *model = _goodsArr[indexPath.row-1];
            SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.model2 = model;
            cell.delegate = self;
            cell.iscollect = [self iscollectioned:model.goodsid];
            [cell.buyButton addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else
    {
        ProductsModel *model = _goodsArr[indexPath.row];
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.model2 = model;
        cell.delegate = self;
        cell.iscollect = [self iscollectioned:model.goodsid];
        [cell.buyButton addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isFromSort)
    {
        if (indexPath.row!= 0) {
    GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
    
    ProductsModel * model  = _goodsArr[indexPath.row-1];
    
    NSDictionary * dic = @{@"appkey":APPkey,@"id":model.goodsid};
    
    goodVC.goodsDic = dic;
    
    [self.navigationController pushViewController:goodVC animated:YES];
        }
    }else
    {
        GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
        
        ProductsModel * model  = _goodsArr[indexPath.row];
        
        NSDictionary * dic = @{@"appkey":APPkey,@"id":model.goodsid};
        
        goodVC.goodsDic = dic;
        
        [self.navigationController pushViewController:goodVC animated:YES];
    }
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
            
            DLog(@"%@",responseObject);
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
        DLog(@"%@",responseObject);
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
            DLog(@"%@",responseObject);
            _detailmodel = [DetailModel mj_objectWithKeyValues:responseObject];
            BookIngViewController * bVC = [[BookIngViewController alloc]init];
            [self.navigationController pushViewController:bVC animated:YES];
            bVC.modelDic = [_detailmodel mj_keyValues];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"failure%@",error);
        }];
    }
}


-(void)sortAction:(UIButton *)sender{
    _goodsArr = [NSMutableArray arrayWithArray:[self isFromWhat:[sender tag]]];
    for (UIButton * button in sender.superview.subviews)
    {
        [button setSelected:NO];
    }
    [sender setSelected:YES];
    
    if (sender.tag == 4) {
        [sender setSelected:YES];
        if (_isUp == NO)
        {
            [sender setTitle:_btnArr[4] forState:UIControlStateSelected];
            _isUp = YES;
        }else
        {
            [sender setTitle:_btnArr[5] forState:UIControlStateSelected];
            _isUp = NO;
        }
    }
    self.introduce = nil;
    [self.goodsTableView reloadData];
    
    [self.goodsTableView setContentOffset:CGPointMake1(0, 0) animated:YES];
}

-(NSArray*)isFromWhat:(NSInteger)tag{
    
    NSArray *sortedArray = [_goodsArr sortedArrayUsingComparator:^(ProductsModel *number1,ProductsModel *number2) {
        int val1,val2;
        switch (tag) {
            case 1:
            {
                val1 = [number1.createtime intValue];
                
                val2 = [number2.createtime intValue];
            }
                break;
            case 2:
            {
                val1 = [number1.viewcount intValue];
                
                val2 = [number2.viewcount intValue];
            }
                break;
                
            case 3:
            {
                val1 = [number1.sales intValue];
                
                val2 = [number2.sales intValue];
            }
                break;
                
            case 4:
            {
                val1 = [number1.marketprice intValue];
                
                val2 = [number2.marketprice intValue];
            }
                break;
                
            default:
                break;
        }
        
        if (val1 > val2) {
            if (tag == 4 && _isUp == YES)
            {
                return NSOrderedDescending;
            }else
                return NSOrderedAscending;
            
        } else {
            
            if (tag == 4 && _isUp == YES)
            {
                return NSOrderedAscending;
            }else
                return NSOrderedDescending;
            
        }
    }];
    return sortedArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isShowTab = YES;
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