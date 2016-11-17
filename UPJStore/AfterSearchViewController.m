//
//  AfterSearchViewController.m
//  UPJStore
//
//  Created by upj on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AfterSearchViewController.h"
#import "AFNetWorking.h"
#import "SearchModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+CG.h"
#import "SearchGoodsCollectionViewCell.h"
#import "GoodSDetailViewController.h"
#import "XLPlainFlowLayout.h"
#import "UIColor+HexRGB.h"
#import "MJRefresh.h"
#import "SearchTableViewCell.h"
#import "CollectModel.h"
#import "LoginViewController.h"
#import "BookIngViewController.h"
#import "DetailModel.h"
#import "MJExtension.h"

@interface AfterSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,btnAction>

@property (nonatomic,strong) UITableView * goodsTableView;
@property (nonatomic,strong) NSMutableArray * goodsArr;
@property (nonatomic,strong)DetailModel *detailmodel;
@property (nonatomic,assign) BOOL isUp;
@property (nonatomic,strong) NSArray * arr;
@property (nonatomic) NSInteger num;
@end

@implementation AfterSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _num = 2;
    
    if (_isFromLBT ==YES)
    {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorFromHexRGB:@"cc2245"]};
        
    }
    if(_KeyWord.length != 0)
    {
        NSDictionary * dic =@{@"appkey":APPkey,@"keyword":_KeyWord};
        [self getDataWithdic:dic];
    }
    else if(_pcate.length != 0)
    {
        NSDictionary * dic =@{@"appkey":APPkey,@"pcate":_pcate};
        [self getDataWithdic:dic];
    }else
    {
        [self initNoneView];
    }
    
    _goodsArr =[NSMutableArray array];
    
    
    // Do any additional setup after loading the view.
}

-(void)initGoodTableView
{
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
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [[UIColor blackColor]CGColor];
        [headerView addSubview:btn];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 39.5, 414, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [self.view addSubview:lineView];

    _goodsTableView  = [[UITableView alloc]initWithFrame:CGRectMake1(0, 40,k6PWidth , k6PHeight-104)];
    _goodsTableView.backgroundColor  = [UIColor whiteColor];
    _goodsTableView.delegate  = self;
    _goodsTableView.dataSource = self;
    _goodsTableView.showsVerticalScrollIndicator = NO;
    _goodsTableView.showsHorizontalScrollIndicator = NO;
    _goodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_goodsTableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_goodsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"header"];
    
    [self.view addSubview:_goodsTableView];
    
}

-(void)getDataWithdic:(NSDictionary *)dic
{
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kSSearchUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // DLog(@"%@",responseObject);
        NSArray* arr = responseObject[@"product"];
        for (NSDictionary *dic in arr) {
            SearchModel * model = [[SearchModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.goodsid = [dic valueForKey:@"id"];
            [_goodsArr addObject: model];
        }
        if (arr.count != 0) {
            [self initGoodTableView];
            if(arr.count == 20)
            {
                _goodsTableView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self postDataWithPage];
                }];
                _goodsTableView.mj_footer.hidden = NO;
            }
        }
        else
        {
            [self initNoneView];
        }
        [_goodsTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)postDataWithPage
{
    NSDictionary *dic = [NSDictionary new];
    if(_KeyWord.length !=0)
    {
        dic =@{@"appkey":APPkey,@"keyword":_KeyWord,@"page":[NSString stringWithFormat:@"%ld",_num]};
    }
    else
    {
        dic =@{@"appkey":APPkey,@"pcate":_pcate,@"page":[NSString stringWithFormat:@"%ld",_num]};
    }
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kSSearchUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  DLog(@"%@",responseObject);
        NSArray* arr = responseObject[@"product"];
        if (arr.count == 20) {
            _num++;
            _goodsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self postDataWithPage];
            }];
        }else
        {
            _goodsTableView.mj_footer.hidden = YES;
        }
        for (NSDictionary *dic in arr) {
            SearchModel * model = [[SearchModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.goodsid = [dic valueForKey:@"id"];
            [_goodsArr addObject: model];
        }
        if (arr.count == 0) {
            _goodsTableView.mj_footer.hidden = YES;
        }else
        {
            [self.goodsTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//当没有东西的时候出现
-(void)initNoneView
{
    UIImageView *noneImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(234/2*414.0/320, 263/2*736.0/568, 336/3, 336/3)];
    noneImageView.image = [UIImage imageNamed:@"afterSearchNone"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake1(70/2*k6PWidth/320, ((39.0/2+263.0/2)*k6PHeight/568+336/3), k6PWidth-70*k6PWidth/320, 60*k6PHeight/568)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"抱歉，没有找到相关的商品，你可以换个词试试";
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    label.textColor = [UIColor colorFromHexRGB:@"999999"];
    
    [self.view addSubview:label];
    
    [self.view addSubview: noneImageView];
    
}


//确定每个item的大小.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFromLBT) {
        if (indexPath.row == 0) {
            return CGFloatMakeY(320);
        }else
        {
            return CGFloatMakeY(120);
        }
    }else
    {
    return CGFloatMakeY(120);
    }
}

//每个分区有几个ITEM
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFromLBT) {
        return _goodsArr.count+1;
    }else
    {
        return _goodsArr.count;
    }
}

//每个ITEM显示什么样的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFromLBT) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"header"];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 414, 320)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_thumb]];
            [cell addSubview:imageView];
            
            return cell;
        }else
        {
            SearchModel *model = _goodsArr[indexPath.row-1];
            SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.model1 = model;
            cell.delegate = self;
            cell.iscollect = [self iscollectioned:model.goodsid];
            [cell.buyButton addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else
    {
        SearchModel *model = _goodsArr[indexPath.row];
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.model1 = model;
        cell.delegate = self;
        cell.iscollect = [self iscollectioned:model.goodsid];
        [cell.buyButton addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isShowTab = NO;
    [self showTabBarWithTabState:self.isShowTab];
    
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
            
         //   DLog(@"%@",responseObject);
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
           // DLog(@"%@",responseObject);
            _detailmodel = [DetailModel mj_objectWithKeyValues:responseObject];
            BookIngViewController * bVC = [[BookIngViewController alloc]init];
            [self.navigationController pushViewController:bVC animated:YES];
            bVC.modelDic = [_detailmodel mj_keyValues];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"failure%@",error);
        }];
    }
}

-(void)btnAction:(UIButton *)btn
{
    _goodsArr =[NSMutableArray arrayWithArray: [self isFromWhat:btn.tag]];
    
    for (UIButton * button in btn.superview.subviews)
    {
        [button setSelected:NO];
    }
    [btn setSelected:YES];
    if (btn.tag != 1003) {
        [(UIButton*)[btn.superview viewWithTag:1003] setSelected:NO];
    }
    if (btn.tag == 1003) {
        [btn setSelected:YES];
        if (_isUp == NO)
        {
            [btn setTitle:_arr[4] forState:UIControlStateSelected];
            _isUp = YES;
        }else
        {
            [btn setTitle:_arr[5] forState:UIControlStateSelected];
            _isUp = NO;
        }
    }
    
    
    [_goodsTableView reloadData];
    [_goodsTableView setContentOffset:CGPointMake1(0, 0)animated:YES];
    
}

-(NSArray*)isFromWhat:(NSInteger)tag
{
    
    NSArray *sortedArray = [_goodsArr sortedArrayUsingComparator:^(SearchModel *number1,SearchModel *number2) {
        int val1,val2;
        switch (tag) {
            case 1000:
            {
                val1 = [number1.createtime intValue];
                
                val2 = [number2.createtime intValue];
            }
                break;
            case 1001:
            {
                val1 = [number1.viewcount intValue];
                
                val2 = [number2.viewcount intValue];
            }
                break;
                
            case 1002:
            {
                val1 = [number1.sales intValue];
                
                val2 = [number2.sales intValue];
            }
                break;
                
            case 1003:
            {
                val1 = [number1.marketprice intValue];
                
                val2 = [number2.marketprice intValue];
            }
                break;
                
            default:
                break;
        }
        
        if (val1 > val2) {
            if (tag == 1003 && _isUp == YES)
            {
                return NSOrderedDescending;
            }else
                return NSOrderedAscending;
            
        } else {
            if (tag == 1003 && _isUp == YES)
            {
                return NSOrderedAscending;
            }else
                return NSOrderedDescending;
        }
    }];
    return sortedArray;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFromLBT) {
        if (indexPath.row != 0) {
            SearchModel *Model =self.goodsArr[indexPath.row-1];
            GoodSDetailViewController * goodDetailVC = [[GoodSDetailViewController alloc]init];
            goodDetailVC.goodsDic = @{@"id":Model.goodsid,@"appkey":APPkey};
            self.navigationItem.title = @"商品详情";
            [self.navigationController pushViewController:goodDetailVC animated:YES];
        }
    }else
    {
    SearchModel *Model =self.goodsArr[indexPath.row];
    GoodSDetailViewController * goodDetailVC = [[GoodSDetailViewController alloc]init];
    goodDetailVC.goodsDic = @{@"id":Model.goodsid,@"appkey":APPkey};
    self.navigationItem.title = @"商品详情";
    [self.navigationController pushViewController:goodDetailVC animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isFromLBT) {
        self.navigationItem.title = _advname;
    }else
        self.navigationItem.title = _KeyWord;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
-(void)pop
{
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
