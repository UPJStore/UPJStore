//
//  ActivityViewController.m
//  UPJStore
//
//  Created by upj on 16/3/28.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ActivityViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "OthersModel.h"
#import "UIColor+HexRGB.h"
#import "ProductsCollectionViewCell.h"
#import "UIViewController+CG.h"
#import "GoodSDetailViewController.h"
#import "UIImageView+WebCache.h"




@interface ActivityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray *brandArr;
@property (nonatomic,strong)UICollectionView *goodsCollectionView;
@property (nonatomic,strong)NSMutableArray *goodsArr;
@property (nonatomic,strong)NSString *cid;

@end

@implementation ActivityViewController
-(NSMutableArray *)brandArr{
    if (!_brandArr) {
        self.brandArr = [NSMutableArray array];
    }
    return _brandArr;
}
-(NSMutableArray *)goodsArr{
    if (!_goodsArr) {
        self.goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _ActivityTitle;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorFromHexRGB:@"cc2245"]};

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
 
    self.navigationController.navigationBar.translucent = YES;

    self.view.backgroundColor = self.backgroundColor;
    
    [self getBrandNameDataWithPid:_pid];
    [self initCollectionView];

    // Do any additional setup after loading the view.
}
-(void)initBtn{

    
    self.headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0,64,CGFloatMakeX(414),CGFloatMakeY(200))];
    [self.headerView setImage:self.headerImg];
    [self.view addSubview:self.headerView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake1(0, 274, 414, 60)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    for (int i = 0; i < _brandArr.count; i++) {
        UIButton *BrandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [BrandBtn setTag:1+i];
        BrandBtn.frame = CGRectMake(((kWidth/_brandArr.count)*i),10, kWidth/_brandArr.count,CGFloatMakeY(40));
        [BrandBtn setTitle:[_brandArr[i] name] forState:UIControlStateNormal];
        [BrandBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(i == 0){
            [BrandBtn setTitleColor:[UIColor colorFromHexRGB:@"cc2245"] forState:UIControlStateNormal];
        }
        BrandBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        BrandBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        BrandBtn.titleLabel.numberOfLines = 0;
        [BrandBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:BrandBtn];
    }
    
}
#pragma mark -- Btn操作
-(void)BtnAction:(UIButton *)sender{

    _cid = [_brandArr[(long)[sender tag]-1] cid];
    [self getGoodsData];
    for (int i = 0; i < _brandArr.count; i++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:i+1];
        if (button == sender) {
            button.selected = YES;
            [sender setTitleColor:[UIColor colorFromHexRGB:@"cc2245"] forState:UIControlStateNormal];
        } else
        {
            button.selected  = NO;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}
-(void)initCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-30)/2,CGFloatMakeY(200));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
    self.goodsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(280), self.view.bounds.size.width, self.view.bounds.size.height-CGFloatMakeY(231)) collectionViewLayout:flowLayout];
    self.goodsCollectionView.delegate = self;
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.goodsCollectionView registerClass:[ProductsCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellReuse"];
    [self.goodsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [self.view addSubview:self.goodsCollectionView];
    
}
-(void)getBrandNameDataWithPid:(NSString *)pid{
    
    NSDictionary * dic =@{@"appkey":APPkey,@"pid":pid};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:kSBrandGoodUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *arr = responseObject;
        for (NSDictionary *dic in arr ) {
            OthersModel *model = [[OthersModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            if ([model.isrecommand isEqualToString:@"1"]) {
                [self.brandArr addObject:model];
            }
        }
        [self initBtn];
        _cid = [_brandArr[0] cid];
        [self getGoodsData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}
-(void)getGoodsData{
    
    NSDictionary * dic =@{@"appkey":APPkey,@"pid":_pid,@"cid":_cid};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:kSBrandGoodUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *arr = responseObject;
        if (_goodsArr) {
            self.goodsArr = [NSMutableArray new];
        }
        for (NSDictionary *dic in arr ) {
            ProductsModel *model = [[ProductsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.productID = [dic valueForKey:@"id"];
            [self.goodsArr addObject:model];
        }
        [self.goodsCollectionView reloadData];
        [self.goodsCollectionView setScrollsToTop:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}
-(void)pop{
    
    self.navigationController.navigationBar.translucent = NO;

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 什么样的cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellReuse" forIndexPath:indexPath];
    
    cell.model = _goodsArr[indexPath.row];
    [cell.productImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,cell.model.thumb]]];

    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake1(414,0);
}
#pragma mark -- 分区头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        return headerView;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
    
    ProductsModel * model  = _goodsArr[indexPath.row];
    
    NSDictionary * dic = @{@"appkey":APPkey,@"id":model.productID};
    
    goodVC.goodsDic = dic;
    
    goodVC.isFromHomePage = YES;

    
    [self.navigationController pushViewController:goodVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
