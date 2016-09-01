//
//  SearchAndSortViewController.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/16.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "SearchAndSortViewController.h"
#import "goodsCollectionViewCell.h"
#import "goodsModel.h"
#import "KindModel.h"
#import "SortView.h"
#import "SortModel.h"
#import "UIViewController+CG.h"
#import "SearchModel.h"
#import "waitSearchCell.h"
#import "AfterSearchViewController.h"
#import "brandViewController.h"
#import "UIButton+WebCache.h"
#import "GoodsViewController.h"



@interface SearchAndSortViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,SortViewAction,UISearchBarDelegate, UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,waitSearchDelegate>

@property (nonatomic,strong) UIScrollView * differentScrollView;
@property (nonatomic,strong) UICollectionView *brandCollectionView;
@property (nonatomic,strong) UIScrollView *sortScrollView;
@property (nonatomic,strong) UIScrollView *brandScrollView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *sortBtn,*brandBtn;
@property (nonatomic,assign) NSInteger i;
@property (nonatomic,assign) NSInteger key;
@property (nonatomic,strong) NSMutableArray * KindArr;
@property (nonatomic,strong) NSMutableArray *BrandArr;
@property (nonatomic,strong) NSMutableArray * headSortArr, *allSortArr;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) UITableView* searchTableView;
@property (nonatomic,strong) NSMutableArray *someThingArr;
@property (nonatomic,assign) CGFloat tableViewCellHeight,tableViewCellHeight0,tableViewCellHeight1;
@property (nonatomic,strong) NSMutableArray *searchRecordArr;
@property (nonatomic,strong) NSUserDefaults * userdefault;
@property (nonatomic,assign)    BOOL shouldBeginEditing;
@property (nonatomic,strong) NSArray * reArr;
@property (nonatomic,strong) UIView * reloadView;
@property (nonatomic,strong)UIView *noNetworkView;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSMutableArray * PcateArr, * desArr;
@property (nonatomic,assign)BOOL isFromhomePage;
@end



@implementation SearchAndSortViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent =NO;
    self.navigationItem.title = @"返回";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initAllArr];
    
    [self getDataWithHeadTitle];
    
    _i = 0;
    _count = 0;
    _userdefault = [NSUserDefaults standardUserDefaults];
    
//    DLog(@"%@",[_userdefault valueForKey:@"recordArr"]);
    
    if ([_userdefault valueForKey:@"recordArr"] == nil) {
        [_userdefault setObject:self.searchRecordArr forKey:@"recordArr"];
    }else
        _searchRecordArr = [NSMutableArray arrayWithArray:[_userdefault valueForKey:@"recordArr"]];
    
    [self initScrollView];
    [self initbrandCollectionView];
    [self initTitleBtn];
    
    [self getSortModelData];
    
    self.searchController.searchBar.delegate=self;
    [self initSearchScrollView];
    
    
    
}


-(void)initAllArr
{
    _BrandArr = [NSMutableArray array];
    _headSortArr = [NSMutableArray array];
    _allSortArr = [NSMutableArray array];
    _searchRecordArr = [NSMutableArray array];
    _someThingArr = [NSMutableArray array];
    _reArr = @[@"奶粉",@"爱他美",@"牛栏",@"纸尿裤",@"花王",@"卫生巾",@"贵爱娘" ,@"swisse",@"Blackmores",@"铁元",@"汤普森",@"洗发",@"羊奶皂",@"新西兰",@"喜宝",@"HIPP",@"帮宝适",@"蜂毒面膜",@"伊思",@"高丝",@"SNP",@"美肌芳程",@"嘉娜宝",@"深海鱼油",@"护肝片",@"椰子水",@"月见草",@"胶原蛋白",@"牙膏"];
}



-(void)initTitleBtn
{
    
    _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sortBtn.frame = CGRectMake1(152, 10, 50, 20);
    [_sortBtn setTitle:@"分类" forState:UIControlStateNormal];
    _sortBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
    [_sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sortBtn addTarget:self action:@selector(sortBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _sortBtn.tag = 100;
    [self.view addSubview:_sortBtn];
    
    _brandBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _brandBtn.frame = CGRectMake1(222, 10, 50, 20);
    [_brandBtn setTitle:@"品牌" forState:UIControlStateNormal];
    _brandBtn.titleLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(18)];
    [_brandBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _brandBtn.tag = 101;
    [_brandBtn addTarget:self action:@selector(brandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_brandBtn];
}
-(void)initbrandCollectionView
{
    
    UIButton * allBrandBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    allBrandBtn.frame = CGRectMake1(10, 10, 414-20, 40);
    [allBrandBtn setBackgroundColor:[UIColor blackColor]];
    [allBrandBtn setTitle:@"选择自己喜欢的品牌吧！" forState:UIControlStateNormal];
    [_brandScrollView addSubview:allBrandBtn];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = CGSizeMake1(110,125);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 30, 20,30);
    
    _brandCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth,_brandScrollView.frame.size.height-60) collectionViewLayout:layout];
    _brandCollectionView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    _brandCollectionView.delegate =self;
    _brandCollectionView.dataSource = self;
    _brandCollectionView.scrollEnabled= NO;
    
    [_brandCollectionView registerClass:[goodsCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [_brandScrollView addSubview:_brandCollectionView];
    
    //collectionView的分区头和分区尾市需要注册的.
    [_brandCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"brandHeader"];
    
    
}

-(void)sortBtnAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        _lineView.frame=CGRectMake1(152, 34, 50, 2/app.autoSizeScaleY);
        _differentScrollView.contentOffset = CGPointMake(0, _differentScrollView.contentOffset.y);
        _differentScrollView.showsVerticalScrollIndicator = FALSE;
    }];
}

-(void)brandBtnAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        _lineView.frame=CGRectMake1(222, 34, 50, 2/app.autoSizeScaleY);
        _differentScrollView.contentOffset = CGPointMake(kWidth, _differentScrollView.contentOffset.y);
    }];
}

-(void)initScrollView
{

    _lineView = [[UIView alloc]initWithFrame:CGRectMake1(152, 34, 50, 2)];
    _lineView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_lineView];
    
    
    _differentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kWidth , kHeight-CGFloatMakeY(150))];
    _differentScrollView.backgroundColor  =[UIColor whiteColor];
    _differentScrollView.contentSize = CGSizeMake(kWidth*2, kHeight-CGFloatMakeY(150));
    _differentScrollView.pagingEnabled = YES;
    _differentScrollView.delegate =self;
    [self.view addSubview:_differentScrollView];
    
    
    _brandScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-100)];
    _brandScrollView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    _brandScrollView.contentSize = CGSizeMake(kWidth, kHeight-49);
    [_differentScrollView addSubview:_brandScrollView];
    
    _sortScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-CGFloatMakeY(150))];
    _sortScrollView.backgroundColor = [UIColor whiteColor];
    _sortScrollView.contentSize = CGSizeMake(kWidth, kHeight*2);
    [_differentScrollView addSubview:_sortScrollView];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView = _differentScrollView;
    if (scrollView.contentOffset.x >kWidth/2) {
        [self brandBtnAction:_brandBtn];
    }
    else if (scrollView.contentOffset.x<kWidth/2)
        [self sortBtnAction:_sortBtn];
}

//确定每个item的大小.
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake1(90, 105);
    
}
 //一共有几个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_KindArr.count == 0) {
        return 0;
    }
    return _KindArr.count;
    
}

#pragma mark -- 分区头分区尾

//分区头
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kWidth, 20);
}

//什么样的分区头或者分区尾
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"brandHeader" forIndexPath:indexPath];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake1(10, 0, 100, 20)];
        label.text = [_KindArr[indexPath.section] name];
        [headerView addSubview:label];
        
        
        headerView.backgroundColor =[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        return headerView;
    }
    return nil;
}


//每个分区有几个ITEM
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_BrandArr.count > 6 ) {
        
        return  [_BrandArr[section] count];
        
    }
    return 0;
}

//每个ITEM显示什么样的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    goodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];

    //获取model
    NSArray * arr =  _BrandArr[indexPath.section];
    NSDictionary *brandDic = arr[indexPath.row];
    goodsModel *model = [[goodsModel alloc]init];
    [model setValuesForKeysWithDictionary:brandDic];
    model.goodSid = [[brandDic valueForKey:@"id"] integerValue];
    
    cell.nameLabel.text = model.name;
    
    NSString *str = [NSString stringWithFormat:kSImageUrl,model.thumb];
    
    [cell.goodsView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    
    
    //    cell.backgroundColor =[UIColor redColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    brandViewController * brandVC = [[brandViewController alloc]init];
    
    brandVC.dic = @{@"appkey":APPkey,@"pid":[_BrandArr[indexPath.section][indexPath.row] valueForKey:@"parentid"],@"cid":[_BrandArr[indexPath.section][indexPath.row] valueForKey:@"id"]};
    brandVC.navigationItem.title = [_BrandArr[indexPath.section][indexPath.row] valueForKey:@"name"];
    
    [self.navigationController pushViewController:brandVC animated:YES];
    
}

-(void)getDataWithHeadTitle
{
    NSDictionary * dic =@{@"appkey":APPkey};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kSBrandGoodUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self hasReloadView];
        NSArray * arr = responseObject;
        for (NSDictionary *dic  in arr) {
            
            KindModel *model = [[KindModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.kindId = [dic valueForKey:@"id"];
            [self.KindArr addObject:model];
            
        }

        [self getModel];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error : %@",error);
        [self ReloadDataWithCase:1];
        
    }];
    
}

-(void)getModel
{
   
    if (_i<_KindArr.count)
    {
        
        KindModel * model = _KindArr[_i];
        NSString * str = model.kindId;
        NSDictionary * dic =@{@"appkey":APPkey,@"pid":str};
        
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [self sharedManager];;

        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];

        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:kSBrandGoodUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            DLog(@"%@",responseObject);
            [self hasReloadView];
            
            NSArray *arr = responseObject;
            
            NSMutableArray *mArr = [NSMutableArray array];
            
            for (NSDictionary * dic  in arr)
            {
                [mArr addObject:dic];
            }
            //            DLog(@"mArr.count : %ld",mArr.count);
            [_BrandArr addObject:mArr];
            _i++;
            [self getModel];
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"error : %@ ",error);
                    [self ReloadDataWithCase:2];
        }];
        
        
    }
    else   {
        
        [_brandCollectionView reloadData];
        
        _brandScrollView.contentSize= CGSizeMake(kWidth,
                                                 //整个collectionView的高度
                                                 [_brandCollectionView.collectionViewLayout collectionViewContentSize].height+100);
        _brandCollectionView.frame = CGRectMake(0, 60, kWidth,_brandScrollView.contentSize.height-44);
    }
}

-(void)initSortView
{
    CGFloat height = 1;
    CGFloat totalHeight = 0;
    for (int i = 0; i<_allSortArr.count ; i++) {
        if ( i > 0) {
            //                    DLog(@" height : %f",height);
            totalHeight  = height +totalHeight;
        }
        UIButton * HeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        HeadBtn.frame = CGRectMake(0, 0, kWidth, CGFloatMakeY(150*414.0/320));
        [HeadBtn sd_setBackgroundImageWithURL:_headSortArr[i] forState:UIControlStateNormal];
        [HeadBtn addTarget:self action:@selector(goToGoodsCollectionView:) forControlEvents:UIControlEventTouchUpInside];
        HeadBtn.tag = [_PcateArr[i] integerValue];
        SortView * sortView = [[SortView alloc]initWithFrame:CGRectMake(0, totalHeight, kWidth,height) withArray:_allSortArr[i]];
        sortView.tag = 100+i;
        
        sortView.delegate = self;
        
        [_sortScrollView addSubview:sortView];
        height = sortView.frame.size.height;
        [sortView addSubview:HeadBtn];
    }
    totalHeight = totalHeight + height;
    _sortScrollView.contentSize = CGSizeMake(kWidth, totalHeight+53);
}

-(void)goToGoodsCollectionView:(UIButton*)btn
{
    GoodsViewController *goodsView = [[GoodsViewController alloc]init];
    goodsView.headerImg = btn.currentBackgroundImage;
    goodsView.pid =[NSString stringWithFormat:@"%ld",btn.tag];
    for (NSDictionary *dic  in _desArr) {
        if ([[dic valueForKey:@"pcate"] isEqualToString:[NSString stringWithFormat:@"%ld",btn.tag]] ) {
                goodsView.introduce = dic[@"name"];

        }
    }
    goodsView.isFromSort = YES;
    [self.navigationController pushViewController:goodsView animated:YES];
}
-(void)initSearchScrollView
{
    
    _searchTableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-60)];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    
    _searchTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchTableView];
    _searchTableView.hidden = YES;
    
    _searchTableView.allowsSelection = NO;
    
    
}

-(void)getSortModelData
{
    
    NSDictionary * dic =@{@"appkey":APPkey,@"num":[NSString stringWithFormat:@"%ld",_count]} ;
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kGetKeyWord parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        
        [self hasReloadView];
        
        NSDictionary * dic = responseObject;
        
        DLog(@"respon %@ ",responseObject);
        
        NSArray * sonArray= dic[@"son"];
        
        [_allSortArr addObject:sonArray];
        
        [_headSortArr addObject:dic[@"thumb"]];
        
        [self.PcateArr addObject:dic[@"pcate"]];
        
        [self.desArr addObject:@{@"name":dic[@"name"],@"pcate":dic[@"pcate"]}];
        
        _count ++;
        [self getSortModelData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
     
        if ([error code] == -1001) {
             [self ReloadDataWithCase:3];
        }else
        {
            _count = 0;
            
            [self initSortView];

        }

        DLog(@"error %@",error);
        
    }];
    
}

-(void)BtnAction:(UIButton *)btn
{
//    DLog(@"%@",btn.titleLabel.text);
    [self goSearchWithStr:btn.titleLabel.text withIsFromBtn:YES];
}


#pragma mark--searchController和searchbar的设置

-(UISearchController *)searchController
{
    if (!_searchController) {
        
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.dimsBackgroundDuringPresentation = NO;
        
        _searchController.hidesNavigationBarDuringPresentation = NO;
        
        _searchController.searchResultsUpdater = self;
        
        UIImage* clearImg = [self imageWithColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1] andHeight:32.0f];
        [_searchController.searchBar setBackgroundImage:clearImg];
        
        [_searchController.searchBar setSearchFieldBackgroundImage:clearImg forState:UIControlStateNormal];
        
        
        
        //        _searchController.searchBar.
        //在导航栏上添加searchBar
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.backgroundColor = [UIColor clearColor];
        //        [self.searchController.searchBar setFrame:CGRectMake(10,10, 20,40)];
        _searchController.searchBar.placeholder = @"最强跨境平台。";
        _searchController.searchBar.layer.cornerRadius = 10;
        _searchController.searchBar.layer.masksToBounds = YES;
        
        //Set to titleView
        
        //        DLog(@"%f",self.searchController.searchBar.frame.size.height);
        
        self.navigationItem.titleView=_searchController.searchBar;
        
    }
    
    return _searchController;
}

-(UIImage*) imageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (_searchController.searchBar.text.length == 0)
    {
        self.searchTableView.allowsSelection = NO;
        [self.searchTableView reloadData];
    }
    else
    [self postTitleWithKey];

    
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    _searchTableView.hidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    if (searchBar.text.length!= 0 ) {
        _searchTableView.allowsSelection =YES;
    }
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    _searchTableView.allowsSelection = YES;
}


-(void)postTitleWithKey
{
    NSDictionary * dic =@{@"appkey":APPkey,@"key":_searchController.searchBar.text};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kTitleURL parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self hasReloadView];
        [_someThingArr removeAllObjects];
        NSArray * arr = responseObject;
        for (NSDictionary * dic  in arr) {
            NSString * title = dic[@"title"];
            
            [_someThingArr addObject:title];
        }
        [_searchTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error %@",error);
                [self ReloadDataWithCase:4];
    }];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self goSearchWithStr:searchBar.text withIsFromBtn:NO];
    BOOL isIN = NO;
    for (NSString * str  in _searchRecordArr) {
        if ([str isEqualToString: searchBar.text]) {
            isIN = YES;
        }
    }
    if (isIN == NO) {
        
        [_searchRecordArr addObject:searchBar.text];
        [_userdefault setObject:self.searchRecordArr forKey:@"recordArr"];

    }
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    _searchTableView.allowsSelection =YES;
    
    
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchTableView.hidden = YES;
    
    self.isShowTab = NO;
    [self showTabBarWithTabState:self.isShowTab];
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_searchController.searchBar.text.length == 0)
    {
        return 1;
    }else
        return _someThingArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_searchController.searchBar.text.length  == 0)
    {
        return 30;
    }return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return   _tableViewCellHeight0;
    }else if (indexPath.section == 1) {
        return _tableViewCellHeight1;
    }else
        return _tableViewCellHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_searchController.searchBar.text.length  == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 30)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake1(5, 5,80, 20)];
        [view addSubview:label];
        label.font  = [UIFont systemFontOfSize:CGFloatMakeY (15)];
        if (section == 0 ) {
            label.text = @"搜索历史";
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"清空记录" forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(clearAllRecord:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.frame = CGRectMake1(414-90, 5, 80, 20);
            [view addSubview: btn];
        }else if (section == 1)
        {
            label.text =@" 热门搜索";
        }
        return view;
    }
    
    return NULL;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchController.searchBar.text.length == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *Identifier = @"cell";
    NSString *sIdentifier = @"sCell";
    if(_searchController.searchBar.text.length == 0)
    {
        
        waitSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        
        if (indexPath.section==0) {
            for (UIView*btn in cell.contentView.subviews) {
                [btn removeFromSuperview];
            }
            if (_searchRecordArr.count == 0) {
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 100, 20)];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"暂无搜索历史。";
                [cell.contentView addSubview:label];
                _tableViewCellHeight0  = 40;
            }
            else
            {
                _tableViewCellHeight0 = [cell addBtnWithArr:[NSMutableArray arrayWithArray:_searchRecordArr]];
            }
        }
        
        if (!cell) {
            cell = [[waitSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.delegate = self;
            if (indexPath.section == 0) {
                _tableViewCellHeight0 = [cell addBtnWithArr:[NSMutableArray arrayWithArray:_searchRecordArr]];
            }else if(indexPath.section == 1)
            {

                _tableViewCellHeight1 = [cell addBtnWithArr:[NSMutableArray arrayWithArray:_reArr]];
            }
        }
        return cell;
    }
    else
    {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sIdentifier];
        }
        
        cell.textLabel.text = _someThingArr[indexPath.row];
        _tableViewCellHeight = 40;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    #pragma 还没加入数组
    [self goSearchWithStr:_someThingArr[indexPath.row] withIsFromBtn:NO];
    
}

-(void)clearAllRecord:(UIButton *)btn
{
//    DLog(@"touch！！！");
    [_searchRecordArr removeAllObjects];
    
    [_searchTableView reloadData];
}

-(void)SearchBtnAction:(UIButton *)btn
{
//    DLog(@"btn %@",btn.titleLabel.text);
    [self goSearchWithStr:btn.titleLabel.text withIsFromBtn:NO];
}

-(void)goSearchWithStr:(NSString *)str withIsFromBtn:(BOOL) isFromBtn
{
    AfterSearchViewController *afsVC = [[AfterSearchViewController alloc]init];
    afsVC.KeyWord = str;
    afsVC.isFromBtn = isFromBtn;
    [self.navigationController pushViewController:afsVC animated:NO];
}





- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        
        [self.searchController.searchBar removeFromSuperview];
    }
    _searchTableView.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isShowTab = NO;
    
    [self showTabBarWithTabState:self.isShowTab];
  /*  if([self returnIsFromHomePage])
    {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        _lineView.frame=CGRectMake1(222, 34, 50, 2/app.autoSizeScaleY);
        _differentScrollView.contentOffset = CGPointMake(kWidth, _differentScrollView.contentOffset.y);
        [self setIsFromHomePagewithIsFromHomePage:NO];
    }
   */
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    if([self returnIsFromHomePage])
    {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        _lineView.frame=CGRectMake1(222, 34, 50, 2/app.autoSizeScaleY);
        _differentScrollView.contentOffset = CGPointMake(kWidth, _differentScrollView.contentOffset.y);
        [self setIsFromHomePagewithIsFromHomePage:NO];
    }
}

#pragma Mark--请求数据超时显示页面；
-(void)ReloadDataWithCase:(NSInteger)count
{
    if(!_noNetworkView){
        [self.differentScrollView removeFromSuperview];
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
        [btn addTarget:self action:@selector(reloadDataBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_noNetworkView];
        [_noNetworkView addSubview:noNetworkImg];
        [_noNetworkView addSubview:noworkLabel];
        [_noNetworkView addSubview:btn];
    }

}


-(void)reloadDataBtn:(UIButton*)btn
{
    [_noNetworkView removeFromSuperview];
    _noNetworkView = nil;
    switch (btn.tag) {
        case 1:
            [self getDataWithHeadTitle];
            break;
        case 2:
            [self getModel];
            break;
        case 3:
            [self getSortModelData];
            break;
        case 4:
            [self postTitleWithKey];
            break;
            
        default:
            break;
    }
}

-(NSMutableArray *)PcateArr
{
    if (_PcateArr == nil) {
        _PcateArr = [NSMutableArray array];
    }
    return _PcateArr;
}


-(NSMutableArray *)KindArr
{
    if (!_KindArr) {
        _KindArr = [NSMutableArray array];
        
    }
    return _KindArr;
}

-(NSMutableArray *)desArr
{
    if (!_desArr) {
        _desArr = [NSMutableArray array];
    }
    return _desArr;
}

-(void)hasReloadView
{
    if (_reloadView != nil) {
        [_reloadView removeFromSuperview];
        _reloadView = nil;
    }
}




@end
