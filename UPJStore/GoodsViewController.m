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

@interface GoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *goodsCollectionView;
@property (nonatomic,strong)NSMutableArray *goodsArr;

@property (nonatomic,strong)NSArray *btnArr;

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
    if (_isFromSort) {
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    }else
    {
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  //  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        
    }
    self.navigationController.navigationBar.translucent = NO;
    [self initCollectionView];
    
    [self getData];
    
    // Do any additional setup after loading the view.
}

-(void)initCollectionView{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    XLPlainFlowLayout *flowLayout = [[XLPlainFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-30)/2,200*app.autoSizeScaleY);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
    self.goodsCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.goodsCollectionView.delegate = self;
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.goodsCollectionView registerClass:[ProductsCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellReuse"];
    [self.goodsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header1"];
    [self.goodsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header2"];
    [self.view addSubview:self.goodsCollectionView];
    
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
            model.productID = [dic valueForKey:@"id"];
            [self.goodsArr addObject:model];
        }
        [self.goodsCollectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
    
}
#pragma mark -- 什么样的cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.goodsArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellReuse" forIndexPath:indexPath];
    
    cell.model = _goodsArr[indexPath.row];
    
    [cell.productImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,cell.model.thumb]]placeholderImage:[UIImage imageNamed:@"lbtP"]];

    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake1(414, 275);
    }
    return CGSizeMake1(414, 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
    
    ProductsModel * model  = _goodsArr[indexPath.row];
    
    NSDictionary * dic = @{@"appkey":APPkey,@"id":model.productID};
    
    goodVC.goodsDic = dic;
    
//    goodVC.isFromHomePage = YES;
    
    
    [self.navigationController pushViewController:goodVC animated:YES];
}

#pragma mark -- 分区头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header1" forIndexPath:indexPath];
            AppDelegate *app = [[UIApplication sharedApplication]delegate];
            
            UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 414, 195)];
            
            headerImgView.image = self.headerImg;
            
            UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10,196, 414-20,80)];
            selectLabel.text = self.introduce;
            selectLabel.numberOfLines = 0;
            selectLabel.font = [UIFont systemFontOfSize:13*app.autoSizeScaleY];
            selectLabel.textAlignment = NSTextAlignmentCenter;
            UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
            selectLabel.textColor = fontcolor;
            
            UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 276*app.autoSizeScaleY, self.view.bounds.size.width, 1)];
            linelabel.backgroundColor = fontcolor;
            
            UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 50)];
            view2.backgroundColor = [UIColor blackColor];
            
            [headerView addSubview:headerImgView];
            [headerView addSubview:selectLabel];
            [headerView addSubview:linelabel];
            return headerView;
            
        }else if(indexPath.section == 1){
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header2" forIndexPath:indexPath];
            AppDelegate *app = [[UIApplication sharedApplication]delegate];
            if (headerView.subviews.count < 1) {
                self.btnArr = @[@"最新",@"人气",@"销量",@"价格",@"价格▼",@"价格▲"];
                UIView *sortView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 50)];
                sortView.backgroundColor = [UIColor whiteColor];
                for (int i = 0; i < 4; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (i==0) {
                        [btn setSelected:YES];
                        [self isFromWhat:1];
                    }
                    [btn setTag:1+i];
                    btn.frame = CGRectMake(((kWidth/4)*i),0, kWidth/4,50*app.autoSizeScaleY);
                    [btn setTitle:_btnArr[i] forState:UIControlStateNormal];
                    btn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                    btn.layer.borderWidth = 1;
                    [btn setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] forState:UIControlStateSelected];
                    [sortView addSubview:btn];
                    
                    [btn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                [headerView addSubview:sortView];
            }
            return headerView;
        }
        
    }
    return nil;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
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
    [self.goodsCollectionView reloadData];
    
    [self.goodsCollectionView setContentOffset:CGPointMake(0, CGFloatMakeY(235)+60) animated:YES];
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