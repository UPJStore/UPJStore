//
//  ViewController.m
//  HomePage
//
//  Created by upj on 16/3/3.
//  Copyright © 2016年 upj. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "UIViewController+CG.h"
#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "CodeViewController.h"
#import "MapViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "LBTModel.h"
#import "CustomCollectionViewCell.h"
#import "ProductModel.h"
#import "UIImageView+WebCache.h"
#import "HeaderModel.h"
#import "GoodsViewController.h"
#import "ActivityViewController.h"
#import "OthersModel.h"
#import "UIColor+HexRGB.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "UIButton+WebCache.h"
#import "GoodSDetailViewController.h"
#import "AfterSearchViewController.h"
#import "AdvertiseViewController.h"


@interface ViewController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UIScrollView *backSrollview;
@property (nonatomic,strong)NSMutableArray*dataArr;
@property (nonatomic,strong)UIButton *miaoShaBtn;
@property (nonatomic,strong)UIButton *activity1;
@property (nonatomic,strong)UIButton *activity2;
@property (nonatomic,strong)UIButton *activity3;
@property (nonatomic,strong)UIButton *activity4;
@property (nonatomic,strong)UIButton *activity5;
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSMutableArray * LBTArr;
@property (nonatomic,strong)NSMutableArray *images;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSString *headerImgURLString;
@property (nonatomic,strong)NSString *goodsPid;
@property (nonatomic,strong)NSMutableArray *productArr;
@property (nonatomic, strong)NSMutableArray *headerArr;
@property (nonatomic,strong)NSString *pid;
@property (nonatomic,strong)NSMutableArray *pidArr;
@property (nonatomic,assign)NSInteger i;
@property (nonatomic,strong)UIView *loadingView;
@property (nonatomic,strong)NSMutableArray *headerIntroArr;
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@property (nonatomic,strong)UIView *noNetworkView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];

    
    _noNetworkView = nil;
#pragma mark -- 初始化数组
    NSString *str = [[NSBundle mainBundle]bundleIdentifier];
    DLog(@"%@",str);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
#pragma mark -- 左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dingwei"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#pragma mark -- 右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saomakuang"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    _dataArr=[[NSMutableArray alloc]init];
    _LBTArr = [NSMutableArray array];
    _productArr = [NSMutableArray new];
    _headerArr = [NSMutableArray new];
    _pidArr = [NSMutableArray new];
    _headerIntroArr = [NSMutableArray new];
    
    _i = 0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"cc2245"];
    
    [self setMBHUD];
    [self getData];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -- 添加广告页面
- (void)pushToAd {
    
    AdvertiseViewController *adVc = [[AdvertiseViewController alloc] init];
    
    [self.navigationController pushViewController:adVc animated:YES];
    
}

#pragma mark -- 加载动画
-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the custom view mode to show any view.
    /*
     _loadingHud.mode = MBProgressHUDModeCustomView;
     UIImage *gif = [UIImage sd_animatedGIFNamed:@"youpinji"];
     
     UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
     _loadingHud.customView = gifView;
     */
    _loadingHud.bezelView.backgroundColor = [UIColor clearColor];
    _loadingHud.animationType = MBProgressHUDAnimationFade;
    _loadingHud.backgroundColor = [UIColor whiteColor];
}
#pragma mark -- 返回
-(void)pop{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 自带标签的图片轮播
-(void)setBackSrollview{
    
    _backSrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-60)];
    _backSrollview.backgroundColor = [UIColor whiteColor];
    _backSrollview.contentSize = CGSizeMake(kWidth, kHeight+1000);
    self.backSrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_backSrollview];
    
    
}
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

#pragma mark -- 轮播点击事件
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    AfterSearchViewController * afSearchVC = [[AfterSearchViewController alloc]init];
    LBTModel * model = _LBTArr[index];
    afSearchVC.KeyWord = model.keyword;
    afSearchVC.thumb = model.thumb;
    afSearchVC.advname = model.advname;
    afSearchVC.descriptionText = model.descriptionText;
    afSearchVC.isFromLBT = YES;
    afSearchVC.backgroundColor = self.view.backgroundColor;
    [self.navigationController pushViewController:afSearchVC animated:YES];}
#pragma mark -- 秒杀活动
-(void)setMiaoSha{
    
    self.miaoShaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.miaoShaBtn.frame = CGRectMake1(5, 175, kWidth-10, 90*1.5-10);
    [self.miaoShaBtn setBackgroundImage:[UIImage imageNamed:@"banner02@3x.png"] forState:UIControlStateNormal];
    self.miaoShaBtn.layer.cornerRadius = 5;
    //    [self.backSrollview addSubview:self.miaoShaBtn];
}
#pragma mark -- 各种活动
-(void)setActivity{
    self.activity1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activity1.tag = 11;
    self.activity1.frame = CGRectMake1(5,200, 414/2-7.5, 120-5);
    [self.activity1 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.upinkji.com/resource/attachment/images/2016/01/332760528997873789.jpg"]]] forState:UIControlStateNormal];
    [self.activity1 addTarget:self action:@selector(ActivityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.activity1.layer.cornerRadius = 5;
    [self.backSrollview addSubview:self.activity1];
    
    self.activity2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activity2.tag = 22;
    self.activity2.frame = CGRectMake1(414/2+2.5, 200, 414/2-7.5, 120-5);
    [self.activity2 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.upinkji.com/resource/attachment/images/2016/01/611268353810817048.jpg"]]] forState:UIControlStateNormal];
    self.activity2.layer.cornerRadius = 5;
    [self.activity2 addTarget:self action:@selector(ActivityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backSrollview addSubview:self.activity2];
    
    self.activity3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activity3.tag = 33;
    self.activity3.frame = CGRectMake1(5,320+2.5,414-10,190-7.5);
    self.activity3.layer.cornerRadius = 5;
    [self.activity3 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.upinkji.com/resource/attachment/images/2016/01/291349526580463032.jpg"]]] forState:UIControlStateNormal];
    
    [self.activity3 addTarget:self action:@selector(ActivityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backSrollview addSubview:self.activity3];
    
    self.activity4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activity4.tag = 44;
    self.activity4.frame = CGRectMake1(5,510+2.5,414-10,190-7.5);
    [self.activity4 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.upinkji.com/resource/attachment/images/2016/01/473757046878255970.jpg"]]] forState:UIControlStateNormal];
    
    self.activity4.layer.cornerRadius = 5;
    [self.activity4 addTarget:self action:@selector(ActivityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backSrollview addSubview:self.activity4];
    
    self.activity5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activity5.tag = 55;
    self.activity5.frame = CGRectMake1(5,700+2.5,414-10,190-7.5);
    [self.activity5 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.upinkji.com/resource/attachment/images/2016/01/21787130544155649.jpg"]]] forState:UIControlStateNormal];
    self.activity5.layer.cornerRadius = 5;
    [self.activity5 addTarget:self action:@selector(ActivityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backSrollview addSubview:self.activity5];
    
    [self setTopic];
}
#pragma mark — 精选活动
-(void)setTopic{
    
    UIView *topic = [[UIView alloc]initWithFrame:CGRectMake1(5, 890, 414-20, 60)];
    UILabel *topicLabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 50)];
    topicLabel.text = @"精选活动";
    topicLabel.textColor = [UIColor darkGrayColor];
    topicLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake1(170,40, 414-340,2)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [topic addSubview:topicLabel];
    [topic addSubview:line];
    [self.backSrollview addSubview:topic];
}
#pragma mark -- 活动Btn
-(void)ActivityBtnAction:(UIButton *)sender{
    ActivityViewController *ActivityVC = [[ActivityViewController alloc]init];
    switch ([sender tag]) {
        case 11:
            ActivityVC.ActivityTitle = @"宝宝奶粉";
            ActivityVC.headerImg = [UIImage imageNamed:@"activity1"];
            ActivityVC.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:240.0/255.0 blue:1.0 alpha:1];
            ActivityVC.pid = @"2";
            break;
        case 22:
            ActivityVC.ActivityTitle = @"宝宝用品";
            ActivityVC.headerImg = [UIImage imageNamed:@"activity2"];
            ActivityVC.backgroundColor = [UIColor colorFromHexRGB:@"FAAADC"];
            ActivityVC.pid = @"5";
            break;
        case 33:
            ActivityVC.ActivityTitle = @"美颜面膜";
            ActivityVC.headerImg = [UIImage imageNamed:@"activity3"];
            ActivityVC.backgroundColor = [UIColor whiteColor];
            ActivityVC.pid = @"21";
            break;
        case 44:
            ActivityVC.ActivityTitle = @"生活家居";
            ActivityVC.headerImg = [UIImage imageNamed:@"activity4"];
            ActivityVC.backgroundColor = [UIColor colorFromHexRGB:@"64B5E0"];
            ActivityVC.pid = @"22";
            break;
        case 55:
            ActivityVC.ActivityTitle = @"营养保健";
            ActivityVC.headerImg = [UIImage imageNamed:@"activity5"];
            ActivityVC.backgroundColor = [UIColor colorFromHexRGB:@"8acb0b"];
            ActivityVC.pid = @"63";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:ActivityVC animated:YES];
    
}
#pragma mark -- 获取数据
-(void)getData{
    NSDictionary * dic =@{@"appkey":APPkey};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:kADV parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        NSArray * arr = responseObject;
        
        for (NSDictionary *dic  in arr)
        {
            
            LBTModel *model = [[LBTModel alloc]init];
            model.descriptionText = dic[@"description"];
            [model setValuesForKeysWithDictionary:dic];
            
            [_LBTArr addObject:model];
        }
        [_images removeAllObjects];
        
        //数据获取完后再添加控件。
        [self getHeaderDataAndModelData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
        [self initWithoutNetworkPage];
        
    }];
    
}

-(void)getHeaderDataAndModelData{
    if (_i<6){
        NSDictionary * dic =@{@"appkey":APPkey,@"num":[NSString stringWithFormat:@"%ld",(long)_i],@"limit":@"6"};
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:kHomePage parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DLog(@"%@",responseObject);
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
            _i++;
            
            [self getHeaderDataAndModelData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"%@",error);
        }];
    }else{
        [self setBackSrollview];
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake1(0, 0, 414,190) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"pltu"];
        NSMutableArray *LBTMarr = [NSMutableArray array];
        for (LBTModel * model  in _LBTArr) {
            [LBTMarr addObject:[NSString stringWithFormat:kSImageUrl,model.thumb]];
        }
        _cycleScrollView.imageURLStringsGroup = LBTMarr;
        
        [_backSrollview addSubview:_cycleScrollView];
        [self setActivity];
        [self setCollectionView];
        [self.collectionView reloadData];
        _collectionView.frame = CGRectMake1(0,950,414,_headerArr.count*600);
        _backSrollview.contentSize = CGSizeMake(CGFloatMakeX(414), (CGFloatMakeY(1100)+_headerArr.count*CGFloatMakeY(600)-64));
        
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
    }
}

#pragma mark -- 断网界面
-(void)initWithoutNetworkPage{
    if(!_noNetworkView){
        [self.backSrollview removeFromSuperview];
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        
        _noNetworkView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 736-64-49)];
        _noNetworkView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *noNetworkImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,100*app.autoSizeScaleY,100*app.autoSizeScaleY)];
        noNetworkImg.center = CGPointMake(kWidth/2, kHeight/2-150*app.autoSizeScaleY);
        noNetworkImg.image = [UIImage imageNamed:@"withoutNetwork"];
        
        UILabel *noworkLabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 20)];
        noworkLabel.text = @"网络不太顺畅哦~";
        noworkLabel.textAlignment = NSTextAlignmentCenter;
        noworkLabel.font = [UIFont boldSystemFontOfSize:14*app.autoSizeScaleY];
        noworkLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        noworkLabel.center = CGPointMake(kWidth/2, kHeight/2-65*app.autoSizeScaleY);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake1(0,0,100,40);
        btn.center = CGPointMake(kWidth/2, kHeight/2-15*app.autoSizeScaleY);
        btn.layer.cornerRadius = 10*app.autoSizeScaleY;
        btn.clipsToBounds = YES;
        [btn setTitle:@"重新加载"forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15*app.autoSizeScaleY];
        btn.backgroundColor = [UIColor colorFromHexRGB:@"cc2245"];
        [btn addTarget:self action:@selector(reloadBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_noNetworkView];
        [_noNetworkView addSubview:noNetworkImg];
        [_noNetworkView addSubview:noworkLabel];
        [_noNetworkView addSubview:btn];
    }
}
-(void)reloadBtn{
    
    [_noNetworkView removeFromSuperview];
    [self viewDidLoad];
    
}
#pragma mark -- collectionView
-(void)setCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake1((414-50)/3,180);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10,7.5,10,7.5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake1(0,555,414,kHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    
    //注册cell
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellReuse"];
    //注册分区头
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [self.backSrollview addSubview:self.collectionView];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
#pragma mark -- 什么样的cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellReuse" forIndexPath:indexPath];

    NSMutableArray * mArr= _productArr[indexPath.section];
    
    cell.model = mArr[indexPath.row];
    
    [cell.productImg sd_setImageWithURL:[NSURL URLWithString:cell.model.thumb]];

    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake1(414,150*414.0/320);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
    
    ProductModel * model  = _productArr[indexPath.section][indexPath.row];
    
    NSDictionary * dic = @{@"appkey":APPkey,@"id":model.productId};
    
    goodVC.goodsDic = dic;
    
    //    goodVC.isFromHomePage = YES;
    
    [self.navigationController pushViewController:goodVC animated:NO];
}
#pragma mark -- 分区头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        HeaderModel *model = _headerArr[indexPath.section];
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerBtn setTag:indexPath.section+1];
        headerBtn.frame = CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height);
        [headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal];
        [headerView addSubview:headerBtn];
        return headerView;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _headerArr.count;
}

-(void)headerBtnAction:(UIButton *)sender{
    
    DLog(@"%ld pid = %@ description : %@.💙",(long)sender.tag,_pidArr[sender.tag-1],[_headerArr[sender.tag-1] descriptionStr]);
    GoodsViewController *goodsView = [[GoodsViewController alloc]init];
    goodsView.headerImg = sender.currentBackgroundImage;
    goodsView.pid = _pidArr[sender.tag-1];
    goodsView.introduce = [_headerArr[sender.tag-1] descriptionStr];
    [self.navigationController pushViewController:goodsView animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.navigationItem.title == nil)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"cc2245"];
        UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigationLogo"]];
        self.navigationItem.titleView = backImg;
        
        self.tabBarController.tabBar.hidden = NO;
    }
    
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
