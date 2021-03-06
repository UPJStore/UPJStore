//
//  GoodSDetailViewController.m
//  UPJStore
//
//  Created by upj on 16/3/29.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "GoodSDetailViewController.h"
#import "AFNetWorking.h"
#import "MJExtension.h"
#import "DetailModel.h"
#import "appraiseModel.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"
#import "UIImageView+WebCache.h"
#import "descriptionView.h"
#import "AppraiseViewController.h"
#import "LoginViewController.h"
#import "CollectModel.h"
#import "BookIngViewController.h"
#import "recommandCell.h"
#import "RecommandModelNSObject.h"
#import "SMPageControl.h"
#import "ShoppingCartViewController.h"
#import "UIButton+WebCache.h"
#import "UIView+Frame.h"
#import "AfterSearchViewController.h"
#import "ActivityModel.h"
#import "GoodsViewController.h"

@interface GoodSDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView * goodsScrollView,* contentScrollView;
@property (nonatomic,strong) NSMutableArray *appraiseArr;
@property (nonatomic,strong) NSMutableArray *thumbArr,*recommandArr;
@property (nonatomic,strong)  DetailModel * model;
@property (nonatomic,strong) descriptionView *descView;
@property (nonatomic,strong) UIView * endView,*ContentView;
@property (nonatomic,strong) UIImageView *isCollectionView;
@property (nonatomic,strong) UILabel *isCollectionLabel;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UILabel * goodsscrollViewLabel,*detailScrollViewLabel;
@property (nonatomic,strong) UIButton * topButton;
@property (nonatomic,retain) SMPageControl *pageControl;
@property (nonatomic,strong) UIView *evaluationView,* recommandView;
@property (nonatomic,strong) UICollectionView *recommandCollectionView;
@property (nonatomic,strong) UIImageView *DetailImageView;
@property (nonatomic,strong) NSMutableArray *activityArr;
@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,strong) NSString *activitystyle;
@property (nonatomic,strong) NSString *activitytitle;
@property (nonatomic,strong) NSString *activityImage;
@property (nonatomic,strong) NSString *activitydes;
@property (nonatomic) BOOL ishaveActivity;
@end

@interface GoodSDetailViewController ()
{
    
    UIAlertController *addToShopCartAlert;
    UIAlertController *collectionGoods;
    
}
@end

@implementation GoodSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"homepageicon"] style:UIBarButtonItemStyleDone target:self action:@selector(gotohomepage)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorFromHexRGB:@"7f828b"];
    self.navigationItem.title = @"商品详情";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Thonburi" size:CGFloatMakeY(20)]};
    
    _activityArr = [NSMutableArray new];
    
    
    if ([self returnMid] == nil || [[self returnMid]isEqualToString:@"0"]) {
        
    }else
    {
        for (CollectModel * model in [self returnCollect]) {
            if ([[_goodsDic valueForKey:@"id"]isEqualToString:[model valueForKey:@"id"]]) {
                _isCollection =YES;
            }
        }
    }
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    [self.view addSubview:self.scrollView];
    [self getActivity];
    
    // Do any additional setup after loading the view.
}


-(void)initEndView
{
    _endView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-CGFloatMakeY(50)-64, kWidth, CGFloatMakeY(50))];
    _endView.backgroundColor = [UIColor whiteColor];
    
    //加入购物车按钮
    UIImageView *ShoppingCartImageView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3, CGFloatMakeY(10), kWidth/3, CGFloatMakeY(20))];
    ShoppingCartImageView.image = [UIImage imageNamed:@"shoppingCart"];
    ShoppingCartImageView.contentMode =UIViewContentModeScaleAspectFit;
    [_endView addSubview:ShoppingCartImageView];
    UILabel * shoppingCartLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/3, CGFloatMakeY(30), kWidth/3, CGFloatMakeY(20))];
    shoppingCartLabel.text = @"加入购物车";
    shoppingCartLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    shoppingCartLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
    shoppingCartLabel.textAlignment = NSTextAlignmentCenter;
    [_endView addSubview:shoppingCartLabel];
    
    UIButton * shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCartBtn.frame = CGRectMake(kWidth/3, 0, kWidth/3, CGFloatMakeY(50));
    [shoppingCartBtn addTarget:self action:@selector(AddToShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [_endView addSubview:shoppingCartBtn];
    
    //收藏按钮
    self.isCollectionView =[[UIImageView alloc]initWithFrame:CGRectMake(0,CGFloatMakeY(10), kWidth/3, CGFloatMakeY(20))];
    _isCollectionView.contentMode =UIViewContentModeScaleAspectFit;
    [_endView addSubview:_isCollectionView];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(k6PWidth/3, CGFloatMakeY(5), CGFloatMakeX(0.5), CGFloatMakeY(40))];
    
    view.backgroundColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_endView addSubview:view];
    self.isCollectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(30), kWidth/3, CGFloatMakeY(20))];
    _isCollectionLabel.textAlignment = NSTextAlignmentCenter;
    [_endView addSubview:_isCollectionLabel];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(0, 0, kWidth/3, CGFloatMakeY(50));
    
    [collectionBtn setSelected:_isCollection];
    collectionBtn.tag = 666;
    _isCollectionLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    _isCollectionLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
    if (collectionBtn.isSelected == YES) {
        _isCollectionView.image  = [UIImage imageNamed:@"isCollection-YES"];
        _isCollectionLabel.text = @"已收藏";
    }else
    {   _isCollectionView.image = [UIImage imageNamed:@"isCollection-NO"];
        _isCollectionLabel.text = @"收藏";
    }
    [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_endView addSubview:collectionBtn];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth/3*2, 0.5)];
    view2.backgroundColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_endView addSubview:view2];
    
    //立即购买按钮
    
    UIButton *buyNowBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    buyNowBtn.frame = CGRectMake(kWidth*2/3, 0, kWidth/3, CGFloatMakeY(50));
    [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    buyNowBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    [buyNowBtn addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
    buyNowBtn.backgroundColor = [UIColor redColor];
    [_endView addSubview:buyNowBtn];
    [self.view addSubview:_endView];
    
}

-(void)hiddenCountView:(UITapGestureRecognizer *)tapG
{
    _ContentView.hidden =YES;
}


-(void)initContentView
{
    _ContentView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight*3, kWidth, kHeight)];
    _ContentView.backgroundColor = [UIColor whiteColor];
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(40), kWidth, kHeight)];
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(kWidth*2, kHeight);
    
    _contentScrollView.scrollEnabled = NO;
    
    [_ContentView addSubview:_contentScrollView];
    _contentScrollView.delegate = self;
    
    UIButton * detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.layer.borderWidth = 0.4;
    detailBtn.layer.borderColor = [[UIColor colorFromHexRGB:@"d9d9d9"]CGColor];
    detailBtn.frame = CGRectMake1(10, 5, k6PWidth/2-10, 28);
    [detailBtn setTitle:@"商品详情" forState:UIControlStateNormal];
    detailBtn.selected = YES;
    detailBtn.tag = 100;
    [detailBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn setTitleColor:[UIColor colorFromHexRGB:@"000000"] forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [detailBtn setBackgroundColor:[UIColor blackColor]];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_ContentView addSubview:detailBtn];
    
    UIButton * FAQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    FAQBtn.layer.borderWidth = 0.4;
    FAQBtn.layer.borderColor = [[UIColor colorFromHexRGB:@"d9d9d9"]CGColor];
    FAQBtn.frame = CGRectMake1(k6PWidth/2, 5, k6PWidth/2-10, 28);
    FAQBtn.tag = 101;
    [FAQBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [FAQBtn setTitle:@"温馨提示" forState:UIControlStateNormal];
    [FAQBtn setTitleColor:[UIColor colorFromHexRGB:@"000000"] forState:UIControlStateNormal];
    [FAQBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [FAQBtn setBackgroundColor:[UIColor whiteColor]];
    FAQBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_ContentView addSubview:FAQBtn];
    
    _DetailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"faq.jpg"]];
    _DetailImageView.frame = CGRectMake(kWidth, 0, kWidth, CGFloatMakeY(550));
    _DetailImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_contentScrollView addSubview:_DetailImageView];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-124-CGFloatMakeY(30))];
    [_webView loadHTMLString:_model.content baseURL:nil];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [_webView reload];
    [_contentScrollView addSubview:_webView];
    [self.view addSubview:_ContentView];
}

-(void)changeView:(UIButton*)btn
{
    UIButton * otherBtn;
    
    if (btn.tag == 100) {
        
        otherBtn = [_ContentView viewWithTag:101];
        [UIView animateWithDuration:0.5 animations:^{
            _contentScrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
    else if (btn.tag == 101)
    {
        otherBtn = [_ContentView viewWithTag:100];
        [UIView animateWithDuration:0.5 animations:^{
            _contentScrollView.contentOffset = CGPointMake(kWidth, 0);
        }];
        
    }
    
    otherBtn.backgroundColor = [UIColor whiteColor];
    otherBtn.selected = NO;
    btn.selected = YES;
    btn.backgroundColor = [UIColor blackColor];
    
}

#pragma 更改收藏状态
-(void)collectionBtn:(UIButton *)btn
{
    if ([[self returnMid]isEqualToString:@"0"] || [self returnMid] == nil) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
        
    }
    else
    {
        [self POSTCollectionData];
    }
}

-(void)POSTCollectionData
{
    NSDictionary * dic =@{@"appkey":APPkey,@"mid":[self returnMid],@"gid":[_goodsDic valueForKey:@"id"]};
#pragma dic MD5
    
    NSDictionary * nDic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kCollectionGoods parameters:nDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      //  DLog(@"%@",responseObject);
        NSDictionary * errDic = responseObject;
        UIButton * btn = [_endView viewWithTag:666];
        NSString * str = errDic[@"errmsg"];
        if (btn.isSelected == YES) {
            _isCollectionView.image = [UIImage imageNamed:@"isCollection-NO"];
            _isCollectionLabel.text = @"收藏";
            
            [btn setSelected:NO];
        }else
        {
            [btn setSelected:YES];
            _isCollectionView.image  = [UIImage imageNamed:@"isCollection-YES"];
            _isCollectionLabel.text = @"已收藏";
            
        }
        
        collectionGoods = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        
        //        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //        }];
        //        [collectionGoods addAction:ok];
        [self presentViewController:collectionGoods animated:YES completion:nil];
        
        DLog(@"    self.presentedViewController %@",self.presentedViewController);
        
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAVC:) userInfo:nil repeats:NO];
        [self postcollect];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


-(void)postcollect
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    [manager POST:kCollectList parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        NSString *errcode = [NSString stringWithFormat:@"%@",number];
        if ([errcode isEqualToString:@"0"]) {
            NSArray *jsonArr = @[];
            [self setCollectwithCollect:jsonArr];
        }else{
            NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
            [self setCollectwithCollect:jsonArr];
        }NSArray *jsonArr1 = [NSArray arrayWithArray:responseObject];
        [self setCollectwithCollect:jsonArr1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)AddToShoppingCart:(UIButton *)btn
{
    if ([[self returnMid]isEqualToString:@"0"]||[self returnMid]==nil) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
        DLog(@"请先登录");
    }
    else  {
        
        [self addGoodsToShoppingCart];
        
    }
}
-(void)goToShoppingCart:(UIButton *)btn
{
    if ([[self returnMid]isEqualToString:@"0"]||[self returnMid]==nil) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
        DLog(@"请先登录");
    }
    else  {
        
        ShoppingCartViewController * shopCarVC = [[ShoppingCartViewController alloc]init];
        shopCarVC.isFromDetail = YES;
        [self.navigationController pushViewController:shopCarVC animated:YES];
        
        
    }
    
}

-(void)buyNowAction:(UIButton *)btn
{
    if ([[self returnMid]isEqualToString:@"0"] || [self returnMid] == nil) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
        
    }
    else
    {
        BookIngViewController * bVC = [[BookIngViewController alloc]init];
        [self.navigationController pushViewController:bVC animated:YES];
        bVC.modelDic = [_model mj_keyValues];
        
        DLog(@"现在购买");
        
        
        
    }
    
    
}
-(void)initdescriptionView
{
    self.descView = [[descriptionView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(300), kWidth, 0) withModel:_model withfromDealer:[self returnIsDealer]];
    _descView.backgroundColor = [UIColor whiteColor];
    
    if (self.ishaveActivity == YES) {
        for (int i = 0; i<_activityArr.count; i++) {
            ActivityModel *model = _activityArr[i];
            UIButton *ActivityBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,self.descView.frame.size.height+CGFloatMakeY(30)*i ,kWidth, CGFloatMakeY(30))];
            [ActivityBtn setBackgroundColor:[UIColor colorFromHexRGB:@"fafafa"]];
            ActivityBtn.tag = i;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake1(12, 3, 40, 24);
            [btn setTitle:model.style forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor redColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
            btn.layer.cornerRadius = 5.0;
            [ActivityBtn addSubview:btn];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(70, 0, 350, 30)];
            label.text = model.title;
            label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            label.textColor = [UIColor colorFromHexRGB:@"767676"];
            [ActivityBtn addSubview:label];
            
            [ActivityBtn addTarget:self action:@selector(activityPush:) forControlEvents:UIControlEventTouchUpInside];
            [self.descView addSubview:ActivityBtn];
        }
        [self.descView setHeight:self.descView.frame.size.height+CGFloatMakeY(30)*_activityArr.count];
    }
    
    [self.scrollView addSubview:_descView];
}

-(void)activityPush:(UIButton*)button
{
    ActivityModel *model = _activityArr[button.tag];
    if (![model.pid isEqualToString:@"0"]) {
        GoodsViewController *goodsView = [[GoodsViewController alloc]init];
        
        goodsView.headerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,model.thumb]]]];
        goodsView.pid = model.pid;
        goodsView.introduce = model.descriptionStr;
        [self.navigationController pushViewController:goodsView animated:YES];
    }else
    {
        
    AfterSearchViewController * afSearchVC = [[AfterSearchViewController alloc]init];
    afSearchVC.KeyWord = model.keyword;
    afSearchVC.thumb = model.thumb;
    afSearchVC.advname = model.keyword;
    afSearchVC.descriptionText = model.descriptionStr;
    afSearchVC.isFromLBT = YES;
    afSearchVC.backgroundColor = self.view.backgroundColor;
    [self.navigationController pushViewController:afSearchVC animated:YES];
    }
}

-(void)initWithInstructionsView
{
    UIView * instructionsView = [[UIView alloc]initWithFrame:CGRectMake(0, _descView.frame.origin.y+_descView.frame.size.height,kWidth, CGFloatMakeY(110))];
    instructionsView.backgroundColor = [UIColor whiteColor];
    
    UILabel * postLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(12), CGFloatMakeY(5), kWidth-CGFloatMakeX(24), CGFloatMakeY(25))];
    if (_model.dispatch == 0) {
        postLabel.text = @"邮费 : 包邮";
    }else
    {     postLabel.text = [NSString stringWithFormat:@"邮费 : ¥%ld",(long)_model.dispatch];
    }
    postLabel.textColor = [UIColor colorFromHexRGB:@"767676"];
    postLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [instructionsView addSubview:postLabel];
    
    UILabel * Label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(10), CGFloatMakeY(30), kWidth-CGFloatMakeX(24), CGFloatMakeY(25))];
    Label1.text = @"服务 : 由友品集在3-7个工作日内发出,并提供售后服务";
    Label1.textColor = [UIColor colorFromHexRGB:@"767676"];
    Label1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [instructionsView addSubview:Label1];
    
    UILabel * Label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(10), CGFloatMakeY(55), kWidth-CGFloatMakeX(24), CGFloatMakeY(25))];
    Label2.text = @"进口税 : 按照国家最新政策,对跨境商品征收相应进口税";
    Label2.textColor = [UIColor colorFromHexRGB:@"767676"];
    Label2.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [instructionsView addSubview:Label2];
    
    UILabel * Label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(10), CGFloatMakeY(80), kWidth-CGFloatMakeX(24), CGFloatMakeY(25))];
    Label3.text = @"提示 : 不支持14天无理由退货";
    Label3.textColor = [UIColor colorFromHexRGB:@"767676"];
    Label3.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [instructionsView addSubview:Label3];
    
    //    instructionsView.layer.borderWidth = 0.3;
    //    instructionsView.layer.borderColor = [[UIColor colorFromHexRGB:@"d9d9d9"]CGColor];
    
    
    [self.scrollView addSubview:instructionsView];
    
}

-(void)initGoodsScrollViewWithPageArr: (NSMutableArray *)pageArr
{
    self.goodsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, CGFloatMakeY(300))];
    _goodsScrollView.backgroundColor = [UIColor whiteColor];
    _goodsScrollView.showsHorizontalScrollIndicator = NO;
    _goodsScrollView.showsVerticalScrollIndicator = NO;
    self.goodsScrollView.contentSize = CGSizeMake(kWidth*pageArr.count, 0);
    self.goodsScrollView.delegate =self;
    self.goodsScrollView.pagingEnabled = YES;
    self.goodsScrollView.tag = 11;
    
    for (int i = 0; i<pageArr.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, CGFloatMakeY(20), kWidth, CGFloatMakeY(260))];
        
        NSString * str = [NSString stringWithFormat:kSImageUrl,pageArr[i]];
        DLog(@"%@",str);
        [imageView sd_setImageWithURL:[NSURL URLWithString:str]placeholderImage:[UIImage imageNamed:@"lbtP"]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_goodsScrollView addSubview:imageView];
        
    }
    
    //UIPageControl 页面控制视图
    
    self.pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, CGFloatMakeY(280),kWidth,CGFloatMakeY(20))];
    
    [self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageIndicon"]];
    [self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"currenticon"]];
    
    self.pageControl.numberOfPages = pageArr.count;
    
    
    [self.pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
    
    [self.scrollView addSubview: _goodsScrollView];
    
}

#pragma mark-添加PageControl
-(void)addPageControl
{
    
    [self.scrollView addSubview:_pageControl];
}


- (void)pageControl:(UIPageControl *)pageControl
{
    // 通过设置scrollView的偏移量来实现图片的切换
    _goodsScrollView.contentOffset = CGPointMake(kWidth * pageControl.currentPage, 0);
}



-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _scrollView.contentSize = CGSizeMake(kWidth, kHeight*2);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        //        _scrollView.backgroundColor  = [UIColor colorFromHexRGB:@"f6f6f6"];
        _scrollView.delegate =self;
        
    }
    
    return _scrollView;
}


-(void)getDataWith:(NSDictionary *)dic
{
    
    [self setMBHUD];
    
#pragma Warn Ndic = dic;
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kGoodDetailURL parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
     //   DLog(@"%@",responseObject);
        _model = [DetailModel mj_objectWithKeyValues:responseObject];
        
        for (NSDictionary * dic  in _model.appraise) {
            
            appraiseModel * model  = [appraiseModel mj_objectWithKeyValues:dic];
            
            [self.appraiseArr addObject:model];
            
        }
        _model.DetailID = [responseObject valueForKey:@"id"];
        _model.detailDescription = [responseObject valueForKey:@"description"];
        
        [self.thumbArr addObject:_model.thumb];
        
        for (NSDictionary * dic in _model.thumb_url) {
            [self.thumbArr addObject:[dic valueForKey:@"attachment"]];
        }
        [self initGoodsScrollViewWithPageArr:_thumbArr];
        [self initdescriptionView];
        [self initWithInstructionsView];
        [self initEvaluationView];
        [self initEndView];
        [self initContentView];
        [self initScrollViewLabel];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
    
}

-(NSMutableArray *)appraiseArr
{
    if (!_appraiseArr) {
        _appraiseArr = [NSMutableArray new];
    }
    return _appraiseArr;
}

-(NSMutableArray*)thumbArr
{
    if (!_thumbArr) {
        _thumbArr = [NSMutableArray array];
    }
    return _thumbArr;
}

-(void)initEvaluationView
{
    _evaluationView = [[UIView alloc]init];
    _evaluationView.backgroundColor = [UIColor whiteColor];
    
    
    
    //
    UILabel * evaluationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, CGFloatMakeY(30))];
    evaluationLabel.text = [NSString stringWithFormat:@"  商品评价（%ld）",_model.appraise.count];
    evaluationLabel.textAlignment = NSTextAlignmentLeft;
    evaluationLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    evaluationLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
    CALayer *evaluationLayer = [evaluationLabel layer];
    CALayer *SSBorder = [CALayer layer];
    SSBorder.borderColor = [UIColor colorFromHexRGB:@"babcbb"].CGColor;
    SSBorder.borderWidth = 0.25;
    SSBorder.frame = CGRectMake(-0.25, evaluationLayer.frame.size.height-0.25, evaluationLayer.frame.size.width, 0.25);
    [evaluationLayer addSublayer:SSBorder];
    [_evaluationView addSubview:evaluationLabel];
    
    CGFloat evaluationVieweHeight = evaluationLabel.frame.size.height;
    
    if (_model.appraise.count == 0)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(30), kWidth ,CGFloatMakeY(40))];
        label.text = @"本商品正在等你来评论喔。";
        label.textAlignment = NSTextAlignmentCenter ;
        [_evaluationView addSubview:label];
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        label.layer.borderWidth = 0.25;
        label.layer.borderColor = [[UIColor colorFromHexRGB:@"babcbb"]CGColor];
        evaluationVieweHeight += label.frame.size.height;
    }
    else
    {
        NSInteger index ;
        
        if (_model.appraise.count > 3)
        {
            index = 3;
        }else
        {
            index = _model.appraise.count;
        }
        CGFloat backViewHeight = 0.00 ;
        for (int i = 0;  i < index; i++)
        {
            appraiseModel *model = _appraiseArr[i];
            UIView * BackView = [[UIView alloc]init];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(25, 9, 200, 20)];
            nameLabel.text = model.nickname;
            nameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            [BackView addSubview:nameLabel];
            
            for (int j = 0; j<[model.star integerValue]; j++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(414-60+j*10, 9, 10, 10)];
                imageView.image = [UIImage imageNamed:@"starIcon"];
                [BackView addSubview:imageView];
            }
            CGFloat DesLength = [model.content boundingRectWithSize:CGSizeMake(414, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(14)]} context:nil].size.height;
            UILabel * ContentLabel = [[UILabel alloc]initWithFrame:CGRectMake1(5, 45, 404, DesLength)];
            ContentLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
            ContentLabel.numberOfLines = 0;
            ContentLabel.text = model.content;
            ContentLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
            [BackView addSubview: ContentLabel];
            
            
            
            evaluationVieweHeight += backViewHeight;
            BackView.frame =CGRectMake(0, evaluationVieweHeight, kWidth,CGFloatMakeY(65+DesLength));
            backViewHeight = 65+DesLength;
            
            CALayer *backLayer = [BackView layer];
            CALayer *backBorder = [CALayer layer];
            backBorder.borderColor = [UIColor colorFromHexRGB:@"d9d9d9"].CGColor;
            backBorder.borderWidth = 0.6;
            backBorder.frame = CGRectMake(-0.6, backLayer.frame.size.height-0.6,backLayer.frame.size.width, 0.6);
            [backLayer addSublayer:backBorder];
            
            [_evaluationView addSubview:BackView];
            
        }
        evaluationVieweHeight += backViewHeight;
    }
    
    UIButton *evaluationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    evaluationBtn.frame = CGRectMake(0, evaluationVieweHeight, kWidth, CGFloatMakeY(30));
    [evaluationBtn setTitle:[NSString stringWithFormat:@"查看更多评论（%ld）",_model.appraise.count] forState:UIControlStateNormal];
    evaluationBtn.layer.borderWidth = 0.3;
    evaluationBtn.layer.borderColor = [[UIColor colorFromHexRGB:@"d9d9d9"]CGColor];
    evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [evaluationBtn addTarget:self action:@selector(goToAppraiseVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [evaluationBtn setTitleColor: [UIColor colorFromHexRGB:@"333333"] forState:UIControlStateNormal];
    [_evaluationView addSubview:evaluationBtn];
    
    
    _evaluationView.frame =CGRectMake(0, CGFloatMakeY(120)+_goodsScrollView.frame.size.height+_descView.frame.size.height, kWidth, evaluationVieweHeight+CGFloatMakeY(30));
    [self.scrollView addSubview:_evaluationView];
    
    _evaluationView.layer.borderColor = [[UIColor colorFromHexRGB:@"333333"]CGColor];
    
    [self getRecommandData];
    [self initRecommandGoodsView];
    
    
}
#pragma 推荐商品

-(void)initRecommandGoodsView
{
    _recommandView = [[UIView alloc]initWithFrame:CGRectMake(0, _evaluationView.frame.origin.y+_evaluationView.frame.size.height+CGFloatMakeY(10), kWidth, CGFloatMakeY(250))];
    _recommandView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview: _recommandView];
    
    UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 0, 40, 40)];
    headerLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    headerLabel.textColor = [UIColor colorFromHexRGB:@"000000"];
    headerLabel.text = @"推荐";
    [_recommandView addSubview: headerLabel];
    
    
    [self.recommandView addSubview:self.recommandCollectionView];
    
    
    self.scrollView.contentSize  = CGSizeMake(kWidth, _recommandView.frame.origin.y+_recommandView.frame.size.height+CGFloatMakeY(160));
    
}

-(void)getRecommandData
{
    NSDictionary * dic = @{@"appkey":APPkey,@"id":_model.DetailID} ;
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kDetailRecommand parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"respon %@",responseObject);
        
        for (NSDictionary *dic in responseObject) {
            RecommandModelNSObject * model = [[RecommandModelNSObject alloc]initWithDictionary:dic];
            [self.recommandArr addObject:model];
        }
        
        [_recommandCollectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error %@",error);
    }];
    
}

-(NSMutableArray *)recommandArr
{
    if (_recommandArr == nil)
    {
        _recommandArr = [NSMutableArray arrayWithCapacity:6];
    }
    return _recommandArr;
}

//确定每个item的大小.
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake1(140, 210);
    
}

//一共有几个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}


//每个分区有几个ITEM
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.recommandArr.count;
}

//每个ITEM显示什么样的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    recommandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    RecommandModelNSObject * goodsModel =self.recommandArr[indexPath.row];
    
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,goodsModel.thumb]]placeholderImage:[UIImage imageNamed:@"lbtP"]];
    
    cell.productLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.productprice];
    cell.marketLabel.text = [NSString stringWithFormat:@"¥%@|",goodsModel.marketprice];
    cell.titleLabel.text = goodsModel.title;
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
    
    RecommandModelNSObject * model  = _recommandArr[indexPath.row];
    
    NSDictionary * dic = @{@"appkey":APPkey,@"id":model.internalBaseClassIdentifier};
    
    goodVC.goodsDic = dic;
    
    [self.navigationController pushViewController:goodVC animated:NO];
}

-(UICollectionView *)recommandCollectionView
{
    if (_recommandCollectionView == nil)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 20;
        //    layout.itemSize = CGSizeMake();
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _recommandCollectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake1(0, 40,k6PWidth, 210) collectionViewLayout:layout];
        _recommandCollectionView.backgroundColor  = [UIColor whiteColor];
        _recommandCollectionView.delegate  = self;
        _recommandCollectionView.dataSource = self;
        _recommandCollectionView.showsHorizontalScrollIndicator = NO;
        _recommandCollectionView.showsVerticalScrollIndicator = NO;
        _recommandCollectionView.layer.borderWidth = 0.3;
        _recommandCollectionView.layer.borderColor = [[UIColor colorFromHexRGB:@"d9d9d9"]CGColor];
        [_recommandCollectionView registerClass:[recommandCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _recommandCollectionView;
}



-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _scrollView) {
        
        if ( scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height+50)
        {
            
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            _ContentView.frame = CGRectMake(0, 0, kWidth, kHeight-CGFloatMakeY(50)-64);
            [UIView commitAnimations];
            self.topButton.hidden = NO;
            _scrollView.scrollEnabled = NO;
        }
    }
    if (scrollView == _webView.scrollView) {
        if (scrollView.contentOffset.y < -50) {
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            _ContentView.frame = CGRectMake(0, kHeight*3, kWidth, kHeight);
            _scrollView.contentOffset = CGPointMake(0, 0);
            [UIView commitAnimations];
            self.topButton.hidden = YES;
            _scrollView.scrollEnabled =YES;
        }
    }
    if (scrollView ==_goodsScrollView) {
        self.pageControl.currentPage = scrollView.contentOffset.x / kWidth;
    }
    
    
}

-(void)initScrollViewLabel
{
    _goodsscrollViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(-30), kWidth, CGFloatMakeY(30))];
    _goodsscrollViewLabel.textAlignment = NSTextAlignmentCenter;
    _goodsscrollViewLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
    _goodsscrollViewLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    _goodsscrollViewLabel.text = @"下拉返回商品详情";
    [_webView.scrollView addSubview:_goodsscrollViewLabel];
    
    _detailScrollViewLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, self.recommandView.frame.origin.y+self.recommandView.frame.size.height+5, kWidth, CGFloatMakeY(30))];
    _detailScrollViewLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    _detailScrollViewLabel.textAlignment = NSTextAlignmentCenter ;
    _detailScrollViewLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
    [_scrollView addSubview:_detailScrollViewLabel];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        if ( scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height+50)
        {
            _detailScrollViewLabel.text = @"释放进入图文详情";
        }else _detailScrollViewLabel.text = @"上拉进入图文详情";
        
    }
    if (scrollView == _webView.scrollView) {
        DLog(@"%.f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y < -50) {
            _goodsscrollViewLabel.text = @"释放返回商品详情";
        }
        else _goodsscrollViewLabel.text = @"下拉返回商品详情";
    }
    
    if (scrollView == _goodsScrollView) {
        self.pageControl.currentPage = (scrollView.contentOffset.x + kWidth/2)/kWidth;
    }
    
}

-(void)getActivity
{
    NSDictionary * dic = @{@"appkey":APPkey} ;
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:KActivity parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   DLog(@"%@",responseObject);
        NSNumber *number = responseObject[@"errcode"];
        NSString *str = [NSString stringWithFormat:@"%@",number];
        if ([str isEqualToString:@"10230"]) {
            self.ishaveActivity = NO;
        }else
        {
            self.ishaveActivity = YES;
            NSArray *arr = [NSArray arrayWithArray:responseObject[@"0"]];
            NSInteger num = 0;
            if (arr.count >3) {
                num = 3;
            }else
            {
                num = arr.count;
            }
            for (int i = 0; i<num; i++) {
                ActivityModel *model = [ActivityModel new];
                [model setValuesForKeysWithDictionary:arr[i]];
                [_activityArr addObject:model];
            }
        }
        [self getDataWith:_goodsDic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error %@",error);
    }];
}

-(void)addGoodsToShoppingCart
{
    [self setMBHUD];
    NSDictionary * dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"id":_model.DetailID,@"amount":@"1"} ;
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kAddGoods parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
     //   DLog(@"%@",responseObject);
        addToShopCartAlert = [UIAlertController alertControllerWithTitle:@"加入购物车成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:addToShopCartAlert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(dismissAVC:) userInfo:nil repeats:NO];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error %@",error);
    }];
    
}
-(void)dismissAVC:(NSTimer *)timer
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)goToAppraiseVC:(UIButton *)btn
{
    AppraiseViewController *appraiseVC = [[AppraiseViewController alloc]init];
    appraiseVC.appraiseArr = _appraiseArr;
    [self.navigationController pushViewController:appraiseVC animated:YES];
    
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_isFromHomePage == YES)
    {
        
        self.navigationController.navigationBar.translucent = YES;
        
    }
    
    
}


-(UIButton *)topButton
{
    if (_topButton == nil) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectMake1(414-70, 450, 50, 50);
        [_topButton setImage:[UIImage imageNamed:@"BackTop"] forState:UIControlStateNormal];
        [_topButton addTarget:self action:@selector(goToTop:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_topButton];
    }
    return _topButton;
}

-(void)goToTop:(UIButton*)btn
{
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationDelegate:self];
    _ContentView.frame = CGRectMake(0, kHeight*3, kWidth, kHeight);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _webView.scrollView.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
    btn.hidden = YES;
    _scrollView.scrollEnabled =YES;
}

-(void)gotohomepage
{
    [UIView animateWithDuration:0.35 animations:^{
        self.tabBarController.selectedIndex = 0;
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
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
