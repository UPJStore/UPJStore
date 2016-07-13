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
#import "SearchGoodsCollectionViewCell.h"
#import "brandModel.h"
#import "GoodSDetailViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"


@interface brandViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign) BOOL isFocus;
@property (nonatomic,strong) UICollectionView * goodsCollectionView;
@property (nonatomic,strong) NSMutableArray *goodsArr ;
@property (nonatomic,strong) UIAlertController * attentionBrand;
@property (nonatomic,strong)MBProgressHUD *loadingHud;
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
    
    
    
//    DLog(@"%@",_dic);
    // Do any additional setup after loading the view.
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
        if (_loadingHud == nil ) {
            [self setMBHUD];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self AttentionBrand];
        }

    }
    
    
  
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


-(void)initGoodCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 20;
    //    layout.itemSize = CGSizeMake();
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 30, 20,30);
    
    _goodsCollectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake1(0, 0,k6PWidth , k6PHeight-60) collectionViewLayout:layout];
    _goodsCollectionView.backgroundColor  = [UIColor whiteColor];
    _goodsCollectionView.delegate  = self;
    _goodsCollectionView.dataSource = self;
    [_goodsCollectionView registerClass:[SearchGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.view addSubview:_goodsCollectionView];
}

-(void)getData
{
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:_dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    
    [manager POST:kSBrandGoodUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray* arrr = responseObject;
        for (NSDictionary * dic in arrr) {
            
            brandModel *model = [[brandModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.goodsID = [dic valueForKey:@"id"];
            [self.goodsArr addObject:model];
        }
        [self initGoodCollectionView];
        [self.goodsCollectionView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        DLog(@"error : %@",error);
        
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
        DLog(@"%@",responseObject);
        
        
#pragma 更改状态；
        if (_isFocus == NO) {
            _isFocus =YES;
            self.navigationItem.rightBarButtonItem.title = @"已关注";
            
        }else
        {
            _isFocus = NO;
            self.navigationItem.rightBarButtonItem.title = @"关注";
        }
         [_loadingHud hideAnimated:YES];

        _loadingHud = nil;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        DLog(@"error : %@",error);
        
    }];
    
    
}


//确定每个item的大小.
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake1(150, 200);
    
}

//一共有几个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



//每个分区有几个ITEM
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.goodsArr.count;
}

//每个ITEM显示什么样的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    brandModel *Model =self.goodsArr[indexPath.row];
    
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,Model.thumb]]placeholderImage:[UIImage imageNamed:@"lbtP"]];
    cell.goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",Model.marketprice];
    cell.titleLabel.text = Model.title;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    brandModel * model = self.goodsArr[indexPath.row];
    GoodSDetailViewController * goodsVC = [[GoodSDetailViewController alloc]init];
    NSDictionary * dic = @{@"appkey":APPkey,@"id":model.goodsID};
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
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
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
