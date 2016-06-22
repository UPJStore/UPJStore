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
#import "detailModel.h"
#import "appraiseModel.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"
#import "UIImageView+WebCache.h"
#import "descriptionView.h"
#import "appraiseViewController.h"
#import "LoginViewController.h"
#import "CollectModel.h"
#import "BookIngViewController.h"


@interface GoodSDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView * goodsScrollView;
@property (nonatomic,strong) NSMutableArray *appraiseArr;
@property (nonatomic,strong) NSMutableArray *thumbArr;
@property (nonatomic,strong)  detailModel * model;
@property (nonatomic,strong) descriptionView *descView;
@property (nonatomic,strong) UIView * endView,*ContentView;
@property (nonatomic,strong) UIImageView *isCollectionView;
@property (nonatomic,strong) UILabel *isCollectionLabel;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UILabel * goodsscrollViewLabel,*detailScrollViewLabel;
@property (nonatomic,strong) UIButton * topButton;
@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,strong) UIView *evaluationView;

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
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"商品详情";

    if (CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, [UIColor colorFromHexRGB:@"cc2245"].CGColor))
    {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }

    
    
    if ([self returnMid] == nil || [[self returnMid]isEqualToString:@"0"]) {
        
    }else
    {
        for (CollectModel * model in [self returnCollect]) {
            if ([[_goodsDic valueForKey:@"id"]isEqualToString:[model valueForKey:@"id"]]) {
                _isCollection =YES;
            }
        }
    }
   
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"999999"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.scrollView];
    [self getDataWith:_goodsDic];
    
    // Do any additional setup after loading the view.
}


-(void)initEndView
{
    _endView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-CGFloatMakeY(50)-64, kWidth, CGFloatMakeY(50))];
    _endView.backgroundColor = [UIColor whiteColor];
    UIImageView *ShoppingCartImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(10), kWidth/3, CGFloatMakeY(20))];
    ShoppingCartImageView.image = [UIImage imageNamed:@"shoppingCart"];
    ShoppingCartImageView.contentMode =UIViewContentModeScaleAspectFit;
    [_endView addSubview:ShoppingCartImageView];
    UILabel * shoppingCartLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(30), kWidth/3, CGFloatMakeY(20))];
    shoppingCartLabel.text = @"加入购物车";
    shoppingCartLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    shoppingCartLabel.textAlignment = NSTextAlignmentCenter;
    [_endView addSubview:shoppingCartLabel];
    
    self.isCollectionView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3,CGFloatMakeY(10), kWidth/3, CGFloatMakeY(20))];
    _isCollectionView.contentMode =UIViewContentModeScaleAspectFit;
    [_endView addSubview:_isCollectionView];
    self.isCollectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/3, CGFloatMakeY(30), kWidth/3, CGFloatMakeY(20))];
    _isCollectionLabel.textAlignment = NSTextAlignmentCenter;
    [_endView addSubview:_isCollectionLabel];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(kWidth/3, 0, kWidth/3, CGFloatMakeY(50));
    
    [collectionBtn setSelected:_isCollection];
    collectionBtn.tag = 666;
    _isCollectionLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    if (collectionBtn.isSelected == YES) {
        _isCollectionView.image  = [UIImage imageNamed:@"isCollection-YES"];
        _isCollectionLabel.text = @"已收藏";
    }else
    {   _isCollectionView.image = [UIImage imageNamed:@"isCollection-NO"];
        _isCollectionLabel.text = @"收藏";
    }
    [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_endView addSubview:collectionBtn];
    UIButton * shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCartBtn.frame = CGRectMake(0, 0, kWidth/3, CGFloatMakeY(50));
    [shoppingCartBtn addTarget:self action:@selector(AddToShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [_endView addSubview:shoppingCartBtn];
    
    UIButton *buyNowBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    buyNowBtn.frame = CGRectMake(kWidth*2/3, 0, kWidth/3, CGFloatMakeY(50));
    [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    buyNowBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    [buyNowBtn addTarget:self action:@selector(buyNowAction:) forControlEvents:UIControlEventTouchUpInside];
    buyNowBtn.backgroundColor = [UIColor colorFromHexRGB:@"cc2245"];
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
    
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, CGFloatMakeY(20))];
    detailLabel.text = @"商品详情";
    detailLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [_ContentView addSubview:detailLabel];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(20), kWidth, kHeight-124-CGFloatMakeY(10))];
    [_webView loadHTMLString:_model.content baseURL:nil];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [_webView reload];
    [_ContentView addSubview:_webView];
    [self.view addSubview:_ContentView];
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
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kCollectionGoods parameters:nDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
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
    else {
        
        [self addGoodsToShoppingCart];
    
    
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
    self.descView = [[descriptionView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(300), kWidth, 0) withModel:_model];
    _descView.backgroundColor = [UIColor whiteColor];
    UILabel *postageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(300),self.descView.frame.size.height-CGFloatMakeY(40) ,CGFloatMakeX(100), CGFloatMakeY(20))];
    postageLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(15)];
    postageLabel.textAlignment = NSTextAlignmentCenter;
    if (_model.dispatch == 0) {
        postageLabel.text = @"邮费: 包邮";
        
    }else
        postageLabel.text = [NSString stringWithFormat:@"邮费：¥%ld",(long)_model.dispatch];
    
    [self.scrollView addSubview:_descView];
    [_descView addSubview:postageLabel];
    
}

-(void)initWithInstructionsView
{
    UIView * instructionsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(300)+_descView.frame.size.height,kWidth, CGFloatMakeY(30))];
    instructionsView.backgroundColor = [UIColor whiteColor];
    
    UILabel * PayLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(10), CGFloatMakeY(5), kWidth-20, CGFloatMakeY(20))];
    PayLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(14)];
    NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithString:@"服务说明：◉微信支付 ◉不支持无理退货 ◉支付宝支付"];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"cc2245"] range:NSMakeRange(11, 1)];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"cc2245"] range:NSMakeRange(5, 1)];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"cc2245"] range:NSMakeRange(20, 1)];
    PayLabel.attributedText = aStr;
    [instructionsView addSubview:PayLabel];
    
    instructionsView.layer.borderWidth = 0.3;
    instructionsView.layer.borderColor = [[UIColor colorFromHexRGB:@"d9d9d9"]CGColor];

    
    [self.scrollView addSubview:instructionsView];

}

-(void)initGoodsScrollViewWithPageArr: (NSMutableArray *)pageArr
{
    self.goodsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, CGFloatMakeY(300))];
    _goodsScrollView.backgroundColor = [UIColor whiteColor];
    self.goodsScrollView.contentSize = CGSizeMake(kWidth*pageArr.count, 0);
    self.goodsScrollView.delegate =self;
    self.goodsScrollView.pagingEnabled = YES;
    self.goodsScrollView.tag = 11;
    
    for (int i = 0; i<pageArr.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, CGFloatMakeY(20), kWidth, CGFloatMakeY(260))];
        
        NSString * str = [NSString stringWithFormat:kSImageUrl,pageArr[i]];
        DLog(@"%@",str);
        [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_goodsScrollView addSubview:imageView];
        
    }
    
    //    UIPageControl  页面控制视图
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGFloatMakeY(280),kWidth,CGFloatMakeY(20))];
    
    // 设置点的个数(页面的个数)
    self.pageControl.numberOfPages = pageArr.count;
    
    [self.pageControl setValue:[UIImage imageNamed:@"pageIndicon"] forKeyPath:@"pageImage"];
    
    [self.pageControl setValue:[UIImage imageNamed:@"currenticon"] forKeyPath:@"currentPageImage"];
    
    
//    // 设置点的颜色
//    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    
    
    
    [self.pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.pageControl];
    [self.scrollView addSubview: _goodsScrollView];
    
}



- (void)pageControl:(UIPageControl *)pageControl
{
    NSLog(@"%ld", pageControl.currentPage);
    // 通过设置scrollView的偏移量来实现图片的切换
    _goodsScrollView.contentOffset = CGPointMake(kWidth * pageControl.currentPage, 0);
}



-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _scrollView.contentSize = CGSizeMake(kWidth, kHeight*2);
//        _scrollView.backgroundColor  = [UIColor colorFromHexRGB:@"f0f0f0"];
        _scrollView.delegate =self;
        
    }
    
    return _scrollView;
}


-(void)getDataWith:(NSDictionary *)dic
{
    
#pragma Warn Ndic = dic;
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:kGoodDetailURL parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        DLog(@"%@",responseObject);
        _model = [detailModel mj_objectWithKeyValues:responseObject];

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
    evaluationLabel.text = [NSString stringWithFormat:@"\t商品评价（%ld）",_model.appraise.count];
    evaluationLabel.textAlignment = NSTextAlignmentLeft;
    evaluationLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    evaluationLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
    [_evaluationView addSubview:evaluationLabel];
    
    CGFloat evaluationVieweHeight = evaluationLabel.frame.size.height;
    
    if (_model.appraise.count == 0)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(30), kWidth,CGFloatMakeY(40))];
        label.text = @"本商品正在等你来评论喔。";
        label.textAlignment = NSTextAlignmentCenter ;
        [_evaluationView addSubview:label];
        label.layer.borderWidth = 0.3;
        label.layer.borderColor = [[UIColor colorFromHexRGB:@"999999"]CGColor];
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
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(5, 9, 200, 20)];
                nameLabel.text = model.nickname;
                [BackView addSubview:nameLabel];
                
                for (int j = 0; j<[model.star integerValue]; j++) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(414-60+j*10, 9, 10, 10)];
                    imageView.image = [UIImage imageNamed:@"starIcon"];
                    [BackView addSubview:imageView];
                }
                CGFloat DesLength = [model.content boundingRectWithSize:CGSizeMake(414, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(15)]} context:nil].size.height;
                UILabel * ContentLabel = [[UILabel alloc]initWithFrame:CGRectMake1(5, 45, 404, DesLength)];
                ContentLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
                ContentLabel.numberOfLines = 0;
                ContentLabel.text = model.content;
                [BackView addSubview: ContentLabel];
                
               BackView.layer.borderWidth = 0.3;
                evaluationVieweHeight += backViewHeight;
                BackView.frame =CGRectMake(0, CGFloatMakeY(evaluationVieweHeight), kWidth,CGFloatMakeY(65+DesLength));
                backViewHeight = 65+DesLength;
                DLog(@"%@",NSStringFromCGRect(BackView.frame));
                
                [_evaluationView addSubview:BackView];
                
            }
        evaluationVieweHeight += backViewHeight;
    }
    
        UIButton *evaluationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        evaluationBtn.frame = CGRectMake(0, evaluationVieweHeight, kWidth, CGFloatMakeY(30));
        [evaluationBtn setTitle:[NSString stringWithFormat:@"查看更多评论（%ld）",_model.appraise.count] forState:UIControlStateNormal];
        evaluationBtn.layer.borderWidth = 0.3;
        evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        [evaluationBtn addTarget:self action:@selector(goToAppraiseVC:) forControlEvents:UIControlEventTouchUpInside];
    
        [evaluationBtn setTitleColor: [UIColor colorFromHexRGB:@"999999"] forState:UIControlStateNormal];
        [_evaluationView addSubview:evaluationBtn];
    
    
    _evaluationView.frame =CGRectMake(0, CGFloatMakeY(50)+_goodsScrollView.frame.size.height+_descView.frame.size.height, kWidth, evaluationVieweHeight+CGFloatMakeY(30));
    [self.scrollView addSubview:_evaluationView];
    if ((_evaluationView.frame.origin.y+evaluationVieweHeight +CGFloatMakeY(20)<kHeight+20)) {
        self.scrollView.contentSize = CGSizeMake(kWidth, kHeight+CGFloatMakeY(60));
    }else
    self.scrollView.contentSize  = CGSizeMake(kWidth, _evaluationView.frame.origin.y+evaluationVieweHeight+CGFloatMakeY(90));
    
    
    _evaluationView.layer.borderColor = [[UIColor colorFromHexRGB:@"333333"]CGColor];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _scrollView) {
        
        if ( scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height+100)
        {
            
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.8];
            [UIView setAnimationDelegate:self];
            _ContentView.frame = CGRectMake(0, 0, kWidth, kHeight-CGFloatMakeY(50)-64);
            [UIView commitAnimations];
              self.topButton.hidden = NO;
            _scrollView.scrollEnabled = NO;
        }
    }
    if (scrollView == _webView.scrollView) {
        if (scrollView.contentOffset.y < -60) {
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.8];
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
    _goodsscrollViewLabel.text = @"下拉返回商品详情";
    [_webView.scrollView addSubview:_goodsscrollViewLabel];
    
    _detailScrollViewLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, self.evaluationView.frame.origin.y+self.evaluationView.frame.size.height, kWidth, CGFloatMakeY(30))];
//    DLog(@"_scrollview.contentSize.height %f",_scrollView.contentSize.height);
    _detailScrollViewLabel.textAlignment = NSTextAlignmentCenter ;
    _detailScrollViewLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
    [_scrollView addSubview:_detailScrollViewLabel];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        if ( scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height+100)
        {
            _detailScrollViewLabel.text = @"释放进入图文详情";
        }else _detailScrollViewLabel.text = @"上拉进入图文详情";
        
           }
    if (scrollView == _webView.scrollView) {
        DLog(@"%.f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y < -60) {
            _goodsscrollViewLabel.text = @"释放返回商品详情";
        }
        else _goodsscrollViewLabel.text = @"下拉返回商品详情";
    }
    
    if (scrollView == _goodsScrollView) {
        self.pageControl.currentPage = (scrollView.contentOffset.x + kWidth/2)/kWidth;
    }

}

-(void)addGoodsToShoppingCart
{
    NSDictionary * dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"id":_model.DetailID,@"amount":@"1"} ;
    
  #pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kAddGoods parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        addToShopCartAlert = [UIAlertController alertControllerWithTitle:@"加入购物车成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [addToShopCartAlert addAction:ok];
        
        [self presentViewController:addToShopCartAlert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAVC:) userInfo:nil repeats:NO];
        
        
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
    appraiseViewController *appraiseVC = [[appraiseViewController alloc]init];
    appraiseVC.appraiseArr = _appraiseArr;
   
    [self.navigationController pushViewController:appraiseVC animated:YES];
    
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    if (_isFromHomePage == YES)
    {
        
        self.navigationController.navigationBar.translucent = YES;
        
    }
    
    if (_isFromCollection)
    {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    else self.tabBarController.tabBar.hidden = NO;
    
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


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.pageControl];
    [self.scrollView bringSubviewToFront:self.pageControl];
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
