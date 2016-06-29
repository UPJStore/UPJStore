//
//  ViewController.m
//  HomePage-3
//
//  Created by upj on 16/6/12.
//  Copyright © 2016年 upj. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIViewController+CG.h"
#import "HomePageTableViewCell.h"
#import "LBTModel.h"
#import "UIImage+GIF.h"
#import "ProductModel.h"
#import "HeaderModel.h"
#import "CustomCollectionViewCell.h"
#import "DetailTableViewCell.h"
#import "GoodsViewController.h"
#import "MapViewController.h"
#import "CodeViewController.h"
#import "ActivityViewController.h"
#import "OthersModel.h"
#import "UIColor+HexRGB.h"
#import "MBProgressHUD.h"

#import "GoodSDetailViewController.h"
#import "AfterSearchViewController.h"


#define kHomePage @"http://m.upinkji.com/api/product/get"

#define kDetailRandom @"http://m.upinkji.com/api/product/detail_random"

#define KpreferDetail @"http://m.upinkji.com/api/product/detail_discount"

#define kADV @"http://m.upinkji.com/api/adv/getadv.html"

#define APPkey @"BwLiQcZIzgUdLx8Bxb"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UITableView *HomePageTableView;
@property (nonatomic,strong)UICollectionView *CollectionView1;
@property (nonatomic,strong)UICollectionView *CollectionView2;
@property (nonatomic,strong)NSMutableArray * LBTArr;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
//三个专区数组
@property (nonatomic,strong)NSMutableArray *pidArr;
@property (nonatomic,strong)NSMutableArray *headerArr;
//特惠商品数组
@property (nonatomic,strong)NSMutableArray *preidArr;
@property (nonatomic,strong)NSMutableArray *preurlArr;
//热门专区数组
@property (nonatomic,strong)NSMutableArray *productArr;
//单品推荐数组
@property (nonatomic,strong)NSMutableArray *detailArr;
@property (nonatomic,assign)NSInteger z;
@property (nonatomic,assign)NSInteger num;
@property (nonatomic,assign)NSInteger detail_random;
@property (nonatomic,strong)UIButton *headerBtn;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"友品集";
    self.view.backgroundColor = [UIColor whiteColor];
#pragma mark -- 左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dingwei"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#pragma mark -- 右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saomakuang"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    _z = 0;
    _num = 0;
    _detail_random = 0;
    _LBTArr = [NSMutableArray new];
    _imageArr = [NSMutableArray new];
    _pidArr = [NSMutableArray new];
    _headerArr = [NSMutableArray new];
    _productArr = [NSMutableArray new];
    _detailArr = [NSMutableArray new];
    [self setTableView];
    
    self.HomePageTableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.HomePageTableView.mj_header beginRefreshing];
}



#pragma mark - 数据获取
//轮播图数据获取
-(void)getData
{
    if (_LBTArr.count == 0)
    {
        NSDictionary * dic =@{@"appkey":APPkey};
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:kADV parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress){}
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSArray * arr = responseObject;
             
             for (NSDictionary *dic  in arr)
             {
                 
                 LBTModel *model = [[LBTModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 [_LBTArr addObject:model];
             }
             [self getHeaderDataAndModelData];
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"%@",error);
             [self.HomePageTableView.mj_header endRefreshing];
             UIAlertController *noAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查你的网络状态🌚" preferredStyle:UIAlertControllerStyleAlert];
             [self.navigationController presentViewController:noAlert animated:YES completion:^{
                 sleep(1);
                 [self.navigationController dismissViewControllerAnimated:YES completion:^{
                     [self.HomePageTableView.mj_header beginRefreshing];
                 }];
             }];
         }];
    }
    else
    {
        [self getHeaderDataAndModelData];
        [self.HomePageTableView.mj_header endRefreshing];
    }
}

//获取秒杀专区数据

//先获取三个专区数据
-(void)getHeaderDataAndModelData
{
    if (_z < 3)
    {
        NSDictionary * dic =@{@"appkey":APPkey,@"num":[NSString stringWithFormat:@"%ld",(long)_num],@"limit":@"6"};
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:kHomePage parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSLog(@"%@",responseObject);
             HeaderModel *Hmodel = [[HeaderModel alloc]init];
             [Hmodel setValuesForKeysWithDictionary:responseObject];
             [_headerArr addObject:Hmodel];
             [_pidArr addObject:Hmodel.pid];
             /*
              NSArray *arr = responseObject[@"list"];
              NSMutableArray * mArr = [NSMutableArray array];
              for (NSDictionary *dic in arr)
              {
              ProductModel *model = [[ProductModel alloc]init];
              [model setValuesForKeysWithDictionary:dic];
              [mArr addObject:model];
              }
              [_productArr addObject:mArr];
              */
             _z++;
             _num++;
             [self getHeaderDataAndModelData];
             
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"%@",error);
             [self.HomePageTableView.mj_header endRefreshing];
         }];
    }
    else
    {
        [self.HomePageTableView reloadData];
        [self.HomePageTableView.mj_header endRefreshing];
        
    }
    if (_z == 3)
    {
        self.HomePageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addData)];
    }
}

//刷新获得特惠商品和热门专区数据
-(void)addData{
    if (_z < 5)
    {
        if (_z == 3) {
            //特惠商品数据获取
            NSDictionary * dic =@{@"appkey":APPkey};
#pragma dic MD5
            NSDictionary * Ndic = [self md5DicWith:dic];
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            [manager POST:KpreferDetail parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
             {
                 
             }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSLog(@"%@",responseObject);
                 _preidArr = [NSMutableArray arrayWithArray:responseObject[@"goodid"]];
                 _preurlArr = [NSMutableArray arrayWithArray:responseObject[@"url"]];
                 _z++;
                 
                 [self.HomePageTableView reloadData];
                 [self addData];
             }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 NSLog(@"%@",error);
                 [self.HomePageTableView.mj_footer endRefreshing];
             }];
        }else if( _z == 4){
            
            NSDictionary * dic =@{@"appkey":APPkey,@"num":@"3",@"limit":@"6"};
#pragma dic MD5
            NSDictionary * Ndic = [self md5DicWith:dic];
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            [manager POST:kHomePage parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
             {
                 
             }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 HeaderModel *Hmodel = [[HeaderModel alloc]init];
                 [Hmodel setValuesForKeysWithDictionary:responseObject];
                 [_headerArr addObject:Hmodel];
                 [_pidArr addObject:Hmodel.pid];
                 NSArray *arr = responseObject[@"list"];
                 NSMutableArray * mArr = [NSMutableArray array];
                 for (NSDictionary *dic in arr)
                 {
                     ProductModel *model = [[ProductModel alloc]init];
                     [model setValuesForKeysWithDictionary:dic];
                     [mArr addObject:model];
                 }
                 [_productArr addObject:mArr];
                 _z++;
                 [self.HomePageTableView reloadData];
                 [self.HomePageTableView.mj_footer endRefreshing];
             }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 NSLog(@"%@",error);
                 [self.HomePageTableView.mj_footer endRefreshing];
             }];
        }
    }else if(_z >= 5 &&_z<43)
    {
        self.HomePageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:nil];
        NSDictionary * dic =@{@"appkey":APPkey,@"num":[NSString stringWithFormat:@"%ld",_detail_random]};
        _detail_random ++;
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:kDetailRandom parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSLog(@"%@",responseObject);
             _z ++;
             ProductModel *model = [[ProductModel alloc]init];
             [model setValuesForKeysWithDictionary:responseObject];
             [_detailArr addObject:model];
             [self.HomePageTableView reloadData];
             [self.HomePageTableView.mj_footer endRefreshing];
             self.HomePageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addData)];
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"%@",error);
             [self.HomePageTableView.mj_footer endRefreshing];
         }];
        
        [self.HomePageTableView reloadData];
        [self.HomePageTableView.mj_footer endRefreshing];
        // [self.HomePageTableView.mj_footer setHidden:YES];
    }else if (_z==43)
    {
        [self.HomePageTableView.mj_footer endRefreshing];
        [self.HomePageTableView.mj_footer setHidden:YES];
    }
}

-(void)setTableView
{
    //tableView 设置
    _HomePageTableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0, 414, 736)];
    _HomePageTableView.delegate = self;
    _HomePageTableView.dataSource = self;
    _HomePageTableView.backgroundColor = [UIColor whiteColor];
    _HomePageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HomePageTableView.showsVerticalScrollIndicator = NO;
    
    [_HomePageTableView registerClass:[HomePageTableViewCell class] forCellReuseIdentifier:@"homepagecell"];
    [_HomePageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lbtcell"];
    [_HomePageTableView registerClass:[DetailTableViewCell class] forCellReuseIdentifier:@"detailcell"];
    
    [self.view addSubview:_HomePageTableView];
    
    //collectionView设置
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    _CollectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake1(0, 40, 414, 330) collectionViewLayout:layout];
    
    _CollectionView1.backgroundColor = [UIColor whiteColor];
    _CollectionView1.delegate = self;
    _CollectionView1.dataSource = self;
    _CollectionView1.showsVerticalScrollIndicator = NO;
    [_CollectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collcell"];
    _CollectionView1.contentSize = CGSizeMake1(414, 330);
    
    UICollectionViewFlowLayout *layout1= [[UICollectionViewFlowLayout alloc]init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _CollectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake1(0, 295, 414, 200) collectionViewLayout:layout1];
    _CollectionView2.backgroundColor = [UIColor whiteColor];
    _CollectionView2.delegate = self;
    _CollectionView2.dataSource = self;
    _CollectionView2.showsVerticalScrollIndicator = NO;
    _CollectionView2.showsHorizontalScrollIndicator = NO;
    
    [_CollectionView2 registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"cocell"];
    _CollectionView2.contentSize = CGSizeMake1(414, 200);
}

#pragma mark - tableView设置

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGFloatMakeY(250);
    }else if(indexPath.row == 1){
        return CGFloatMakeY(0);
    }else if(indexPath.row <= 4){
        return CGFloatMakeY(300);
    }else if(indexPath.row == 5)
    {
        return CGFloatMakeY(380);
    }else if(indexPath.row == 6)
    {
        return CGFloatMakeY(500);
    }else
    {
        return CGFloatMakeY(430);
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_headerArr.count == 0) {
        return 4;
    }else
    {
        return _z+2;
    }
}

//根据每行的数据进行分类。
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lbtcell"];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake1(0, 0, 414,250) delegate:self placeholderImage:[UIImage imageNamed:@"pltu"]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _imageArr = [NSMutableArray array];;
        for (LBTModel *model in _LBTArr) {
            [_imageArr addObject:[NSString stringWithFormat:@"http://www.upinkji.com/resource/attachment/%@",model.thumb]];
        }
        _cycleScrollView.imageURLStringsGroup = _imageArr;
        [cell addSubview:_cycleScrollView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lbtcell"];
        
        //  HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
        //  cell.footView.frame = CGRectMake1(0, 490, 414, 10);
        //  cell.titleLabel.text = @" ——  限时抢购  —— ";
        
        //限时抢购
        //  UIView *view = [[UIView alloc]initWithFrame:CGRectMake1(0, 40, 414, 450)];
        //   view.backgroundColor = [UIColor grayColor];
        //   [cell addSubview:view];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row <= 4)
    {
        HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
        cell.footView.frame = CGRectMake1(0, 290, 414, 10);
        if(_headerArr.count != 0){
            HeaderModel *model = _headerArr[indexPath.row-2];
            _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_headerBtn setTag:indexPath.row-2];
            [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal];
            _headerBtn.frame = CGRectMake1(0, 40, 414, 250);
            [_headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_headerBtn];
            cell.titleLabel.text =[NSString stringWithFormat:@" ——  %@  —— ",model.name];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row <=6)
    {
        HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
        if(indexPath.row == 5)
        {
            //  cell.backgroundColor = [UIColor redColor];
            cell.titleLabel.text = @" ——  特惠商品  —— ";
            //  cell.footView.frame = CGRectMake1(0, 370, 414, 10);
            [cell addSubview:_CollectionView1];
        }else if(indexPath.row == 6)
        {
            cell.titleLabel.text = @" ——  热门专区  —— ";
            HeaderModel *model = _headerArr[3];
            _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_headerBtn setTag:3];
            [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal];
            _headerBtn.frame = CGRectMake1(0, 40, 414, 250);
            [_headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_headerBtn];
            [cell addSubview:_CollectionView2];
            //   cell.backgroundColor = [UIColor blueColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        DetailTableViewCell *cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailcell"];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 0.5)];
        lineView1.backgroundColor = [UIColor grayColor];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 39.5, 414, 0.5)];
        lineView2.backgroundColor = [UIColor grayColor];
        [cell addSubview:lineView1];
        [cell addSubview:lineView2];
        cell.titleLabel.text = @"单品推荐";
        cell.backgroundColor = [UIColor whiteColor];
        
        ProductModel *model = _detailArr[indexPath.row-7];
        cell.model = model;
        [cell.detailImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.upinkji.com/resource/attachment/%@",model.thumb]]];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - collectionView设置

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _CollectionView1)
    {
        return 6;
    }else if(collectionView == _CollectionView2)
    {
        return 6;
    }
    else
    {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _CollectionView1) {
        UICollectionViewCell *cell = [_CollectionView1 dequeueReusableCellWithReuseIdentifier:@"collcell" forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 200, 100)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.upinkji.com/%@",_preurlArr[indexPath.row]]]];
        cell.backgroundView = imageView;
        return cell;
    }else if (collectionView == _CollectionView2) {
        CustomCollectionViewCell *cell = [_CollectionView2 dequeueReusableCellWithReuseIdentifier:@"cocell" forIndexPath:indexPath];
        NSMutableArray * mArr= _productArr[0];
        
        cell.model = mArr[indexPath.row];
        
        [cell.productImg sd_setImageWithURL:[NSURL URLWithString:cell.model.thumb]];
        // cell.backgroundColor = [UIColor redColor];
        return cell;
    }else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collcell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blueColor];
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _CollectionView1) {
        return CGSizeMake1(200, 100);
    }else if(collectionView == _CollectionView2)
    {
        return CGSizeMake1(128, 150);
    }else
    {
        return CGSizeMake1(200, 200);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上，左，下，右
    if (collectionView == _CollectionView1) {
        return UIEdgeInsetsMake(5, 0, 0, 0);
    }else if(collectionView == _CollectionView2)
    {
        return UIEdgeInsetsMake(0, 5, 0, 0);
    }else
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark -- 点击方法
-(void)leftAction:(UIBarButtonItem *)btn{
    DLog(@"定位");
    MapViewController *mapView = [[MapViewController alloc]init];
    [self.navigationController pushViewController:mapView animated:YES];
}
-(void)rightAction:(UIBarButtonItem *)btn{
    DLog(@"扫码");
    CodeViewController *codeView = [[CodeViewController alloc]init];
    [self.navigationController pushViewController:codeView animated:YES];
}

//轮播点击事件
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LBTModel * model = _LBTArr[index];
    NSLog(@"%@",model.lbid);
    
    AfterSearchViewController * afSearchVC = [[AfterSearchViewController alloc]init];
    afSearchVC.KeyWord = model.keyword;
    afSearchVC.thumb = model.thumb;
    afSearchVC.advname = model.advname;
    afSearchVC.descriptionText = model.descriptionStr;
    afSearchVC.isFromLBT = YES;
    afSearchVC.backgroundColor = self.view.backgroundColor;
    [self.navigationController pushViewController:afSearchVC animated:YES];
    
    
}
//单品点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >6) {
        ProductModel *model = _detailArr[indexPath.row-7];
        GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
        NSDictionary * dic = @{@"appkey":APPkey,@"id":model.productId};
        
        goodVC.goodsDic = dic;
        
        goodVC.isFromHomePage = YES;
        
        [self.navigationController pushViewController:goodVC animated:YES];
    }
}

//每个cell的图片点击方法
-(void)headerBtnAction:(UIButton *)sender
{
    NSLog(@"%ld pid = %@ description : %@.💙",(long)sender.tag,_pidArr[sender.tag],[_headerArr[sender.tag] descriptionStr]);
    
    GoodsViewController *goodsView = [[GoodsViewController alloc]init];
    goodsView.headerImg = sender.currentBackgroundImage;
    goodsView.pid = _pidArr[sender.tag];
    goodsView.introduce = [_headerArr[sender.tag] descriptionStr];
    [self.navigationController pushViewController:goodsView animated:YES];
    
}


//小分区的点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _CollectionView1) {
        GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
        NSString *pid = [NSString stringWithFormat:@"%@",_preidArr[indexPath.row]];
        NSDictionary * dic = @{@"appkey":APPkey,@"id":pid};
        
        goodVC.goodsDic = dic;
        
        goodVC.isFromHomePage = YES;
        
        [self.navigationController pushViewController:goodVC animated:YES];
        
    }else if(collectionView == _CollectionView2)
    {
        GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
        ProductModel * model  = _productArr[0][indexPath.row];
        NSDictionary * dic = @{@"appkey":APPkey,@"id":model.productId};
        
        goodVC.goodsDic = dic;
        
        goodVC.isFromHomePage = YES;
        
        [self.navigationController pushViewController:goodVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
