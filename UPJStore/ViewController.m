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
#import "UIButton+WebCache.h"
#import "UIViewController+CG.h"
#import "HomePageTableViewCell.h"
#import "LBTModel.h"
#import "ImageModel.h"
#import "UIImage+GIF.h"
#import "ProductModel.h"
#import "HeaderModel.h"
#import "GoodsViewController.h"
#import "MapViewController.h"
#import "CodeViewController.h"
#import "ActivityViewController.h"
#import "OthersModel.h"
#import "MBProgressHUD.h"
#import "GoodSDetailViewController.h"
#import "AfterSearchViewController.h"
#import "CollectModel.h"
#import "LoginViewController.h"
#import "ImageTableViewCell.h"
#import "UIButton+WebCache.h"
#import "DetailModel.h"
#import "MJExtension.h"
#import "BookIngViewController.h"
#import "CategoryModel.h"
#import "brandViewController.h"
#import "LbtWebViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,btnAction>
@property (nonatomic,strong)UITableView *HomePageTableView;
@property (nonatomic,strong)UICollectionView *CollectionView1;
@property (nonatomic,strong)UICollectionView *CollectionView2;
@property (nonatomic,strong)NSMutableArray * LBTArr;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic,strong)DetailModel *detailmodel;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
//三个专区数组
@property (nonatomic,strong)NSMutableArray *pidArr;
@property (nonatomic,strong)NSMutableArray *headerArr;
//特惠商品数组
@property (nonatomic,strong)NSMutableArray *preidArr;
@property (nonatomic,strong)NSMutableArray *preurlArr;
//热门专区数组
@property (nonatomic,strong)NSMutableArray *productArr;
//品牌推荐数组
@property (nonatomic,strong)NSMutableArray *categoryArr;
@property (nonatomic,assign)NSInteger z;
@property (nonatomic,assign)NSInteger num;
@property (nonatomic,assign)NSInteger detail_random;
@property (nonatomic,strong)UIButton *headerBtn;
@property (nonatomic,strong)NSMutableArray *homepageImageArr;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //   self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorFromHexRGB:@"cc2245"]};
#pragma mark - 左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dingwei"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorFromHexRGB:@"999999"];
    
#pragma mark - 右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saomakuang"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorFromHexRGB:@"999999"];
    
    _z = 0;
    _num = 2;
    _LBTArr = [NSMutableArray new];
    _imageArr = [NSMutableArray new];
    _pidArr = [NSMutableArray new];
    _headerArr = [NSMutableArray new];
    _productArr = [NSMutableArray new];
    _homepageImageArr = [NSMutableArray new];
    _categoryArr =[NSMutableArray new];
    if ([self returnIsLogin]) {
        [self postcollect];
    }
    [self setTableView];
    
    self.HomePageTableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.HomePageTableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    if(self.navigationItem.title == nil)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigationLogo"]];
        backImg.contentMode = UIViewContentModeScaleAspectFit;
        self.navigationItem.titleView = backImg;
        
        self.isShowTab = NO;
        [self showTabBarWithTabState:self.isShowTab];
        
        [_HomePageTableView reloadData];
    }
    
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
        
        AFHTTPSessionManager * manager = [self sharedManager];
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
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
             [self getHomepageImageData];
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"%@",error);
             [self.HomePageTableView.mj_header endRefreshing];
             UIAlertController *noAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查你的网络状态🌚" preferredStyle:UIAlertControllerStyleAlert];
             [self.navigationController presentViewController:noAlert animated:YES completion:^{
                 sleep(1);
                 [self.navigationController dismissViewControllerAnimated:YES completion:^{
                     //  [self.HomePageTableView.mj_header beginRefreshing];
                 }];
             }];
         }];
    }
    else
    {
        [self getHomepageImageData];
        [self.HomePageTableView.mj_header endRefreshing];
    }
}

-(void)getHomepageImageData
{
    NSDictionary * dic =@{@"appkey":APPkey};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:kHomepageImage parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"%@",responseObject);
         for (NSDictionary *dic in responseObject) {
             ImageModel *model = [ImageModel new];
             [model setValuesForKeysWithDictionary:dic];
             [_homepageImageArr addObject:model];
         }
         // [_HomePageTableView reloadData];
         [self getHeaderDataAndModelData];
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
         [self.HomePageTableView.mj_header endRefreshing];
     }];
    
}


//先获取一个专区数据
-(void)getHeaderDataAndModelData
{
    if (_z < 1)
    {
        NSDictionary * dic =@{@"appkey":APPkey,@"num":[NSString stringWithFormat:@"%ld",(long)_num]};
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [self sharedManager];;
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:kHomePage parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSLog(@"%@",responseObject);
             NSArray *arr = responseObject[@"list"];
             if (arr.count != 0) {
             HeaderModel *Hmodel = [[HeaderModel alloc]init];
             [Hmodel setValuesForKeysWithDictionary:responseObject];
             [_headerArr addObject:Hmodel];
             [_pidArr addObject:Hmodel.pid];
             NSMutableArray * mArr = [NSMutableArray array];
             for (NSDictionary *dic in arr)
             {
                 ProductModel *model = [[ProductModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 [mArr addObject:model];
             }
             [_productArr addObject:mArr];
             _z++;
             _num++;
             [self getHeaderDataAndModelData];
             }
             else
             {
                 _num++;
                 [self getHeaderDataAndModelData];
             }
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
    if (_z == 1)
    {
        self.HomePageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addData)];
    }
}

//刷新获得特惠商品和热门专区数据
-(void)addData{
    if (_z < 5)
    {
        if (_z == 1) {
            NSDictionary * dic =@{@"appkey":APPkey,@"num":[NSString stringWithFormat:@"%ld",(long)_num]};
#pragma dic MD5
            NSDictionary * Ndic = [self md5DicWith:dic];
            
            AFHTTPSessionManager * manager = [self sharedManager];;
            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            [manager POST:kHomePage parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
             {
                 
             }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSLog(@"%@",responseObject);
                 NSArray *arr = responseObject[@"list"];
                 if (arr.count != 0) {
                 HeaderModel *Hmodel = [[HeaderModel alloc]init];
                 [Hmodel setValuesForKeysWithDictionary:responseObject];
                 [_headerArr addObject:Hmodel];
                 [_pidArr addObject:Hmodel.pid];
                 NSMutableArray * mArr = [NSMutableArray array];
                 for (NSDictionary *dic in arr)
                 {
                     ProductModel *model = [[ProductModel alloc]init];
                     [model setValuesForKeysWithDictionary:dic];
                     [mArr addObject:model];
                 }
                 [_productArr addObject:mArr];
                 _z++;
                 _num++;
                 [self.HomePageTableView reloadData];
                 [self.HomePageTableView.mj_footer endRefreshing];
             }else
             {
                 _num++;
                 [self addData];
             }
             }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 NSLog(@"%@",error);
                 [self.HomePageTableView.mj_footer endRefreshing];
             }];
        }else if(_z == 2)
        {
            _z++;
            [self addData];
        }else if( _z == 3||_z ==4){
            
            NSDictionary * dic =@{@"appkey":APPkey,@"num":[NSString stringWithFormat:@"%ld",(long)_num]};
#pragma dic MD5
            NSDictionary * Ndic = [self md5DicWith:dic];
            
            AFHTTPSessionManager * manager = [self sharedManager];;
            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            [manager POST:kHomePage parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
             {
                 
             }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                  NSArray *arr = responseObject[@"list"];
                 if (arr.count != 0) {
                 HeaderModel *Hmodel = [[HeaderModel alloc]init];
                 [Hmodel setValuesForKeysWithDictionary:responseObject];
                 [_headerArr addObject:Hmodel];
                 [_pidArr addObject:Hmodel.pid];
                 NSMutableArray * mArr = [NSMutableArray array];
                 for (NSDictionary *dic in arr)
                 {
                     ProductModel *model = [[ProductModel alloc]init];
                     [model setValuesForKeysWithDictionary:dic];
                     [mArr addObject:model];
                 }
                 [_productArr addObject:mArr];
                 _z++;
                 _num++;
                 [self.HomePageTableView reloadData];
                 [self.HomePageTableView.mj_footer endRefreshing];
                 }else
                 {
                     _num++;
                     [self addData];
                 }
             }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 NSLog(@"%@",error);
                 [self.HomePageTableView.mj_footer endRefreshing];
             }];
        }
    }else if (_z==5)
    {
        NSDictionary * dic =@{@"appkey":APPkey};
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [self sharedManager];;
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:KCategory     parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSLog(@"%@",responseObject);
             NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject[@"children"][@"2"]];
             NSArray *arr = [NSArray arrayWithArray:[dic allKeys]];
             for (int i = 0; i<15; i++) {
                 CategoryModel *model = [CategoryModel new];
                 NSString *str = arr[i];
                 NSDictionary *dict = dic[str];
                 [model setValuesForKeysWithDictionary:dict];
                 [_categoryArr addObject:model];
             }
             _z++;
             [self.HomePageTableView reloadData];
             [self.HomePageTableView.mj_footer endRefreshing];
             [self.HomePageTableView.mj_footer setHidden:YES];
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"%@",error);
             [self.HomePageTableView.mj_footer endRefreshing];
         }];
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
    [_HomePageTableView registerClass:[ImageTableViewCell class] forCellReuseIdentifier:@"imagecell1"];
    [_HomePageTableView registerClass:[ImageTableViewCell class] forCellReuseIdentifier:@"imagecell2"];
    
    [self.view addSubview:_HomePageTableView];
}

#pragma mark - tableView设置

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return CGFloatMakeY(320);
            break;
        case 1:
            return CGFloatMakeY(270);
            break;
        case 4:
            return CGFloatMakeY(250);
            break;
        case 7:
            return CGFloatMakeY(320);
            break;
        default:
            return CGFloatMakeY(1507.5);
            break;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_headerArr.count == 0) {
        return 3;
    }else
    {
        return _z+2;
    }
}

//根据每行的数据进行分类。
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lbtcell"];
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake1(0, 0, 414,320) delegate:self placeholderImage:[UIImage imageNamed:@"lbtP"]];
            _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            _imageArr = [NSMutableArray array];;
            for (LBTModel *model in _LBTArr) {
                [_imageArr addObject:[NSString stringWithFormat:@"http://www.upinkji.com/resource/attachment/%@",model.thumb]];
            }
            _cycleScrollView.imageURLStringsGroup = _imageArr;
            [cell addSubview:_cycleScrollView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            ImageTableViewCell *cell = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imagecell1"];
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"全球优品，海淘达人都买这些\nThe global optimum,overseas online shopping to buy these talent"];
            [attributeString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(14)]} range:NSMakeRange(0, 13)];
            [attributeString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(8)]} range:NSMakeRange(13, 64)];
            cell.label1.attributedText = attributeString;
            
            NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:@"全球购物体验站\nUPIN SHOP SHOPPING OVERSEAS"];
            [attributeString1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(14)]} range:NSMakeRange(0, 7)];
            [attributeString1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(8)]} range:NSMakeRange(7,28)];
            cell.label2.attributedText = attributeString1;
            
            if(_homepageImageArr.count != 0)
            {
                ImageModel *model = [ImageModel new];
                model = _homepageImageArr[0];
                [cell setImageWithImage1:model.url];
                model = _homepageImageArr[1];
                [cell setImageWithImage2:model.url];
                model = _homepageImageArr[2];
                [cell setImageWithImage3:model.url];
            }
            cell.btn1.tag = 10;
            [cell.btn1 addTarget:self  action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn2.tag = 11;
            [cell.btn2 addTarget:self  action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn3.tag = 12;
            [cell.btn3 addTarget:self  action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
            if(_headerArr.count != 0){
                HeaderModel *model = _headerArr[indexPath.row-2];
                _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_headerBtn setTag:indexPath.row-2];
                [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal];
                _headerBtn.frame = CGRectMake1(0, 0, 414, 217.5);
                [_headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_headerBtn];
            }
            if (_productArr.count != 0) {
                cell.modelArr = [NSArray arrayWithArray:_productArr[0]];
                cell.islogin = [self returnIsLogin];
                cell.collectArr = [self returnCollect];
                [cell tableViewreflash];
            }
            cell.deletage = self;
            [cell.button setTag:indexPath.row-2];
            [cell.button addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:
        {
            HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
            if(_headerArr.count != 0){
                HeaderModel *model = _headerArr[indexPath.row-2];
                _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_headerBtn setTag:indexPath.row-2];
                [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lbtP"]];
                _headerBtn.frame = CGRectMake1(0, 0, 414, 217.5);
                [_headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_headerBtn];
            }
            if (_productArr.count != 0) {
                cell.modelArr = [NSArray arrayWithArray:_productArr[1]];
                [cell tableViewreflash];
            }
            cell.deletage = self;
            [cell.button setTag:indexPath.row-2];
            [cell.button addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lbtcell"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake1(0, 0, 414, 217.5);
            ImageModel *model = _homepageImageArr[3];
            button.tag = 13;
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lbtP"]];
            [button addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 250, 414, 50)];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"友品集·全球购,全球购物体验站\nUPIN SHOP SHOPPING OVERSEAS"];
            [attributeString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(14)]} range:NSMakeRange(0, 15)];
            [attributeString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(8)]} range:NSMakeRange(15, 27)];
            label.attributedText = attributeString;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 5:
        {
            HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
            if(_headerArr.count != 0){
                HeaderModel *model = _headerArr[indexPath.row-3];
                _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_headerBtn setTag:indexPath.row-3];
                [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lbtP"]];
                _headerBtn.frame = CGRectMake1(0, 0, 414, 217.5);
                [_headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_headerBtn];
            }
            if (_productArr.count != 0) {
                cell.modelArr = [NSArray arrayWithArray:_productArr[2]];
                [cell tableViewreflash];
            }
            cell.deletage = self;
            [cell.button setTag:indexPath.row-3];
            [cell.button addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 6:
        {
            HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
            if(_headerArr.count != 0){
                HeaderModel *model = _headerArr[indexPath.row-3];
                _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_headerBtn setTag:indexPath.row-3];
                [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lbtP"]];
                _headerBtn.frame = CGRectMake1(0, 0, 414, 217.5);
                [_headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_headerBtn];
            }
            if (_productArr.count != 0) {
                cell.modelArr = [NSArray arrayWithArray:_productArr[3]];
                [cell tableViewreflash];
            }
            cell.deletage = self;
            [cell.button setTag:indexPath.row-3];
            [cell.button addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 7:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lbtcell"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 50)];
            label.text = @"品牌推荐栏目\nBrand recommendation column";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor redColor];
            label.textAlignment = 1;
            [cell addSubview:label];
            for (int i = 0; i<4; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake1(10+101*i, 55, 91, 50);
                CategoryModel *model = _categoryArr[i];
                [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.thumb]] forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:self action:@selector(categoryTapAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
            }
            for (int i = 4; i<8; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake1(10+101*(i-4),110, 91, 50);
                CategoryModel *model = _categoryArr[i];
                [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.thumb]] forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:self action:@selector(categoryTapAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
            }
            for (int i = 8; i<12; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake1(10+101*(i-8), 165, 91, 50);
                CategoryModel *model = _categoryArr[i];
                [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.thumb]] forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:self action:@selector(categoryTapAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
            }
            for (int i =12 ; i<15; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake1(10+101*(i-12), 220, 91, 50);
                CategoryModel *model = _categoryArr[i];
                [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.thumb]] forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:self action:@selector(categoryTapAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
            }
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake1(0, 280, 414, 40);
            [button setTitle:@"更多品牌点这里 more" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            [button addTarget:self action:@selector(moreCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"morearrow.png"]];
            imageView.frame = CGRectMake1(278, 10, 20, 20);
            [button addSubview:imageView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
        {
            HomePageTableViewCell *cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepagecell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
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

#pragma mark - 点击方法
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
   
    if (model.keyword.length != 0 || model.pcate.length != 0) {
        AfterSearchViewController * afSearchVC = [[AfterSearchViewController alloc]init];
        afSearchVC.pcate = model.pcate;
        afSearchVC.thumb = model.thumb;
        afSearchVC.pcate = model.pcate;
        afSearchVC.advname = model.advname;
        afSearchVC.descriptionText = model.descriptionStr;
        afSearchVC.isFromLBT = YES;
        afSearchVC.backgroundColor = self.view.backgroundColor;
        [self.navigationController pushViewController:afSearchVC animated:YES];
    }else
    {
        LbtWebViewController *lbtvc = [[LbtWebViewController alloc]init];
        lbtvc.titlestr = model.advname;
        lbtvc.urlstr = model.link;
        [self.navigationController pushViewController:lbtvc animated:YES];
    }
    
}


//每个cell的图片点击方法
-(void)headerBtnAction:(UIButton *)sender
{
    NSLog(@"%ld pid = %@ description : %@.💙",(long)sender.tag,_pidArr[sender.tag],[_headerArr[sender.tag] descriptionStr]);
    
    GoodsViewController *goodsView = [[GoodsViewController alloc]init];
    HeaderModel *model = _headerArr[sender.tag];
    goodsView.headerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.thumb]]]];
    goodsView.pid = _pidArr[sender.tag];
    goodsView.introduce = [_headerArr[sender.tag] descriptionStr];
    [self.navigationController pushViewController:goodsView animated:YES];
    
}

-(void)imageBtnAction:(UIButton *)sender
{
    AfterSearchViewController * afSearchVC = [[AfterSearchViewController alloc]init];
    ImageModel *model = _homepageImageArr[sender.tag - 10];
    afSearchVC.KeyWord = model.keyword;
    afSearchVC.pcate = model.pcate;
    afSearchVC.isFromLBT = NO;
    [self.navigationController pushViewController:afSearchVC animated:YES];
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

-(BOOL)collectNowAction:(UIButton *)btn
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

-(void)didselectAction:(NSString *)pid
{
    GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
    NSDictionary * dic = @{@"appkey":APPkey,@"id":pid};
    
    goodVC.goodsDic = dic;
    
    goodVC.isFromHomePage = YES;
    
    [self.navigationController pushViewController:goodVC animated:YES];
}

-(void)categoryTapAction:(UIButton*)btn
{
    brandViewController * brandVC = [[brandViewController alloc]init];
    CategoryModel *model = _categoryArr[btn.tag];
    brandVC.dic = @{@"appkey":APPkey,@"pid":model.parentid,@"cid":model.cateid};
    brandVC.navigationItem.title = model.name;
    
    [self.navigationController pushViewController:brandVC animated:YES];
}

-(void)moreCategoryAction:(UIButton*)btn
{
    self.tabBarController.selectedIndex = 1;
    [self setIsFromHomePagewithIsFromHomePage:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
