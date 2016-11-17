//
//  MyShopViewController.m
//  UPJStore
//
//  Created by upj on 16/10/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyShopViewController.h"
#import "UIViewController+CG.h"
#import "CategoryModel.h"
#import "ShopGoodsModel.h"
#import "MyShopGoodsTableViewCell.h"
#import "MJRefresh.h"
#import "GoodSDetailViewController.h"

@interface MyShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIView *SeachView;
@property(nonatomic,strong)UITextField *SeachTextField;
@property(nonatomic,strong)UIView *ButtonView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *oneView;
@property(nonatomic,strong)UIView *twoView;
@property(nonatomic,strong)NSArray *oneArr;
@property(nonatomic,strong)NSMutableDictionary *twoDic;
@property(nonatomic,strong)NSString *cateid;
@property(nonatomic,strong)NSString *sort;
@property(nonatomic,strong)NSArray *twoArr;
@property(nonatomic,strong)NSArray *tableArr;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,strong)UICollectionView *collectionView1;
@property(nonatomic,strong)UICollectionView *collectionView2;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *redlineView1;
@property(nonatomic,strong)UIView *redlineView2;
@property(nonatomic)NSInteger i;
@end

@implementation MyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorFromHexRGB:@"f6f6f6"];
    self.navigationItem.title = @"我的店铺";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    _i = 2;
    _cateid = @"0";
    _oneArr = [NSArray new];
    _twoArr = [NSArray new];
    _tableArr = [NSArray new];
    _twoDic = [NSMutableDictionary new];
    [self initWithSeachView];
}

-(void)initWithSeachView
{
    _SeachView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 50)];
    _SeachView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_SeachView];
    
    UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake1(0, 0, 40, 40)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake1(10, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"SeachImg"];
    [rightVeiw addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [rightVeiw addGestureRecognizer:tap];
    
    _SeachTextField = [[UITextField alloc]initWithFrame:CGRectMake1(20, 5, 374, 40)];
    _SeachTextField.backgroundColor = [UIColor colorFromHexRGB:@"ececec"];
    _SeachTextField.placeholder = @"请在这里输入名称马上搜索";
    _SeachTextField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    _SeachTextField.rightView = rightVeiw;
    _SeachTextField.borderStyle = UITextBorderStyleRoundedRect;
    _SeachTextField.rightViewMode = UITextFieldViewModeAlways;
    [_SeachView addSubview:_SeachTextField];
    
    _ButtonView = [[UIView alloc]initWithFrame:CGRectMake1(0, 50, 414, 40)];
    _ButtonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_ButtonView];
    
    _arr = @[@"最新",@"人气",@"销量",@"销量▲",@"销量▼",@"价格",@"价格▲",@"价格▼"];
    for(int i = 0; i<4;i++)
    {
        
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake1(i*k6PWidth/4, 0, k6PWidth/4, 40);
        btn.tag = 1000+i;
        [btn setTitle:_arr[i] forState:UIControlStateNormal];
        if(i == 3)
        {
            [btn setTitle:_arr[5] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [[UIColor blackColor]CGColor];
        [_ButtonView addSubview:btn];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 89, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [self.view addSubview:lineView];
    [self initWithScrollView];
}

-(void)initWithScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake1(0, 90, 414, 582)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.bounces = NO;
    _scrollView.scrollsToTop = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [self postWithCategory];
}

-(void)initWithOneView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(CGFloatMakeX(138), CGFloatMakeY(30));
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 60) collectionViewLayout:layout];
    if (_oneArr.count%3 == 0) {
        _collectionView1.frame = CGRectMake1(0, 0, 414, 30*_oneArr.count/3);
    }else
    {
        _collectionView1.frame = CGRectMake1(0, 0, 414, 30*(_oneArr.count/3+1));
    }
    _collectionView1.delegate = self;
    _collectionView1.dataSource = self;
    _collectionView1.backgroundColor = [UIColor whiteColor];
    [_collectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectView1"];
    [_scrollView addSubview:_collectionView1];
    _redlineView1 = [[UIView alloc]init];
    _redlineView1.backgroundColor = [UIColor redColor];
    [_collectionView1 addSubview:_redlineView1];
    [self initWithTwoView];
}

-(void)initWithTwoView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(CGFloatMakeX(138), CGFloatMakeY(30));
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _collectionView1.frame.origin.y+_collectionView1.frame.size.height, k6PWidth, 0) collectionViewLayout:layout];
    _collectionView2.delegate = self;
    _collectionView2.dataSource = self;
    _collectionView2.backgroundColor = [UIColor whiteColor];
    [_collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectView2"];
    [_scrollView addSubview:_collectionView2];
    _redlineView2 = [[UIView alloc]init];
    _redlineView2.backgroundColor = [UIColor redColor];
    [_collectionView2 addSubview:_redlineView2];
    
    [self initWithTableViwe];
}

-(void)initWithTableViwe
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 0) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[MyShopGoodsTableViewCell class] forCellReuseIdentifier:@"tableView"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"none"];
    [_scrollView addSubview:_tableView];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"page":[NSString stringWithFormat:@"%ld",_i]};
        [self postWithNextGoods:dic];
    }];
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid]};
    [self postWithGoods:dic];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView1) {
        return _oneArr.count;
    }else if(collectionView == _collectionView2 )
    {
        return _twoArr.count;
    }else
    {
        return 0;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collectionView1)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectView1" forIndexPath:indexPath];
        CategoryModel *model = _oneArr[indexPath.row];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 138, 30)];
        label.text = model.name;
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [cell addSubview:label];
        return cell;
    }else if(collectionView == _collectionView2)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectView2" forIndexPath:indexPath];
        CategoryModel *model = _twoArr[indexPath.row];
        for (id subView in cell.subviews) {
            [subView removeFromSuperview];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 138, 30)];
        label.text = model.name;
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [cell addSubview:label];
        return cell;
    }else
    {
        UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_SeachTextField resignFirstResponder];
    if (collectionView == _collectionView1) {
        _redlineView1.frame = CGRectMake1(30+138*(indexPath.row%3), 25+30*(indexPath.row/3), 78, 2);
        _redlineView2.hidden = YES;
        CategoryModel *model = _oneArr[indexPath.row];
        NSArray *textarr = _twoDic[model.cateid];
        _twoArr = [NSArray arrayWithArray:textarr];
        if(_twoArr.count >15)
        {
            _collectionView2.frame = CGRectMake(0, _collectionView1.frame.origin.y+_collectionView1.frame.size.height, 414, 30*5);
            _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth, 582);
            _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
        }else{
            if (_twoArr.count%3 == 0) {
                _collectionView2.frame = CGRectMake(0, _collectionView1.frame.origin.y+_collectionView1.frame.size.height, 414, 30*_twoArr.count/3);
                _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth, 582);
                _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
            }else
            {
                _collectionView2.frame = CGRectMake(0, _collectionView1.frame.origin.y+_collectionView1.frame.size.height, 414, 30*(_twoArr.count/3+1));
                _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth, 582);
                _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
            }}
        [_collectionView2 reloadData];
        
        
    }else if(collectionView == _collectionView2)
    {
        _redlineView2.hidden = NO;
        _redlineView2.frame = CGRectMake1(30+138*(indexPath.row%3), 25+30*(indexPath.row/3), 78, 2);
        CategoryModel *model = _twoArr[indexPath.row];
        NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"ccate":model.cateid};
        _cateid = model.cateid;
        [self postWithSecondGoods:dic];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_tableArr.count != 0)
    {
        return _tableArr.count;
    }else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(100);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableArr.count != 0) {
        MyShopGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView" forIndexPath:indexPath];
        ShopGoodsModel *model = _tableArr[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return cell;
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none" forIndexPath:indexPath];
        cell.textLabel.text = @"暂无任何数据";
        cell.textLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        cell.textLabel.textAlignment = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_SeachTextField resignFirstResponder];
    GoodSDetailViewController *GDVC = [GoodSDetailViewController new];
    ShopGoodsModel *model = _tableArr[indexPath.row];
    NSDictionary *dic = @{@"appkey":APPkey,@"id":model.gid};
    GDVC.goodsDic = dic;
    [self.navigationController pushViewController:GDVC animated:YES];
    
}

//获得一二级分类
-(void)postWithCategory
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KCategory parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSNull class]]) {
            NSMutableArray *arr1 = [NSMutableArray new];
            NSDictionary *dic2 = [NSDictionary dictionaryWithDictionary:responseObject[@"children"]];
            for (NSDictionary *textDic in responseObject[@"category"]){
                CategoryModel *model = [CategoryModel new];
                [model setValuesForKeysWithDictionary:textDic];
                [arr1 addObject:model];
            }
            _oneArr = [NSArray arrayWithArray:arr1];
            for (NSString*key in dic2.allKeys) {
                NSDictionary *dic3 = dic2[key];
                NSMutableArray *arr2 = [NSMutableArray new];
                for (NSDictionary *dic4 in dic3.allValues) {
                    CategoryModel *model = [CategoryModel new];
                    [model setValuesForKeysWithDictionary:dic4];
                    [arr2 addObject:model];
                }
                [_twoDic setObject:arr2 forKey:key];
            }
        }
        [self initWithOneView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postWithCategory];
    }];
}

//获得刚进来的商品
-(void)postWithGoods:(NSDictionary*)dic
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KMyShopGetShopgoods parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *textArr = [NSMutableArray new];
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if([errcode isEqualToString:@"12366"])
        {
            for (NSDictionary *textdic in responseObject[@"errmsg"]) {
                ShopGoodsModel *model = [ShopGoodsModel new];
                [model setValuesForKeysWithDictionary:textdic];
                [textArr addObject:model];
            }
            _tableArr = [NSArray arrayWithArray:textArr];
            if (_tableArr.count == 20) {
                _tableView.mj_footer.hidden = NO;
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"page":[NSString stringWithFormat:@"%ld",_i]};
                    [self postWithNextGoods:dic];
                }];
            }else
            {
                _tableView.mj_footer.hidden = YES;
            }
            _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth, 582);
            _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postWithGoods:dic];
    }];
}

//获得二级商品点击的商品
-(void)postWithSecondGoods:(NSDictionary*)dic
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KMyShopGetShopgoods parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *textArr = [NSMutableArray new];
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        _i = 0;
        if([errcode isEqualToString:@"12366"])
        {
            for (NSDictionary *textdic in responseObject[@"errmsg"]) {
                ShopGoodsModel *model = [ShopGoodsModel new];
                [model setValuesForKeysWithDictionary:textdic];
                [textArr addObject:model];
            }
            _tableArr = [NSArray arrayWithArray:textArr];
            if (_tableArr.count <4) {
                _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth,350);
                
                _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
            }else
            {
                _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth, _tableArr.count*100);
                
                _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
            }
            
            if (_tableArr.count == 20) {
                _tableView.mj_footer.hidden = NO;
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"page":[NSString stringWithFormat:@"%ld",_i]};
                    [self postWithNextGoods:dic];
                }];
            }else
            {
                _tableView.mj_footer.hidden = YES;
            }
            
            [_tableView reloadData];
        }else if([errcode isEqualToString:@"12356"])
        {
            _tableArr = [NSArray new];
            _tableView.mj_footer.hidden = YES;
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postWithSecondGoods:dic];
    }];
}

//获得下一页商品
-(void)postWithNextGoods:(NSDictionary*)dic
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KMyShopGetShopgoods parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:nil];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *textArr = [NSMutableArray arrayWithArray:_tableArr];
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if([errcode isEqualToString:@"12366"])
        {
            _i++;
            NSArray *earr = [NSArray arrayWithArray:responseObject[@"errmsg"]];
            for (NSDictionary *textdic in earr) {
                ShopGoodsModel *model = [ShopGoodsModel new];
                [model setValuesForKeysWithDictionary:textdic];
                [textArr addObject:model];
            }
            if (earr.count == 20) {
                _tableView.mj_footer.hidden = NO;
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"page":[NSString stringWithFormat:@"%ld",_i]};
                    [self postWithNextGoods:dic];
                }];
            }else
            {
                _tableView.mj_footer.hidden = YES;
            }
            _tableArr = [NSArray arrayWithArray:textArr];
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postWithSecondGoods:dic];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_SeachTextField resignFirstResponder];
    if (scrollView == _scrollView) {
        CGPoint point = scrollView.contentOffset;
        if(point.y >= (_collectionView1.frame.size.height+_collectionView2.frame.size.height))
        {
            _tableView.scrollEnabled = YES;
        }else
        {
            _tableView.scrollEnabled = NO;
        }
    }
}

//排序按钮功能
-(void)btnAction:(UIButton *)btn
{
    for (UIButton *button in btn.superview.subviews) {
        [button setSelected:NO];
    }
    [btn setSelected:YES];
    switch (btn.tag) {
        case 1000:
        {
            _sort = @"5";
        }
            break;
        case 1001:
        {
            _sort = @"4";
        }
            break;
        case 1002:
        {
            _sort = @"3";
            btn.tag = 1004;
            [btn setTitle:@"销量▲" forState:UIControlStateSelected];
        }
            break;
        case 1003:
        {
            _sort = @"1";
            btn.tag = 1006;
            [btn setTitle:@"价格▲" forState:UIControlStateSelected];
        }
            break;
        case 1004:
        {
            _sort = @"4";
            btn.tag = 1005;
            [btn setTitle:@"销量▼" forState:UIControlStateSelected];
        }
            break;
        case 1005:
        {
            _sort = @"3";
            btn.tag = 1004;
            [btn setTitle:@"销量▲" forState:UIControlStateSelected];
        }
            break;
        case 1006:
        {
            _sort = @"2";
            [btn setTitle:@"价格▼" forState:UIControlStateSelected];
            btn.tag = 1007;
        }
            break;
        case 1007:
        {
            _sort = @"1";
            [btn setTitle:@"价格▲" forState:UIControlStateSelected];
            btn.tag = 1006;
        }
            break;
        default:
            break;
    }
    if ([_cateid isEqualToString:@"0"]) {
        NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"sort":_sort};
        [self postWithSortGoods:dic];
    }else
    {
        NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"ccate":_cateid,@"sort":_sort};
        [self postWithSortGoods:dic];
    }
}

//获得排序后的商品
-(void)postWithSortGoods:(NSDictionary*)dic
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KMyShopGetShopgoods parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *textArr = [NSMutableArray new];
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if([errcode isEqualToString:@"12366"])
        {
            for (NSDictionary *textdic in responseObject[@"errmsg"]) {
                ShopGoodsModel *model = [ShopGoodsModel new];
                [model setValuesForKeysWithDictionary:textdic];
                [textArr addObject:model];
            }
            _tableArr = [NSArray arrayWithArray:textArr];
            if (_tableArr.count == 20) {
                _i = 2;
                _tableView.mj_footer.hidden = NO;
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"page":[NSString stringWithFormat:@"%ld",_i]};
                    [self postWithNextGoods:dic];
                }];
            }else
            {
                _tableView.mj_footer.hidden = YES;
            }
            _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth, 582);
            _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
            [_tableView reloadData];
        }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         DLog(@"failure%@",error);
         [self postWithSortGoods:dic];
     }];
}

//点击搜索按钮
-(void)tapAction
{
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"kw":_SeachTextField.text};
    [self postWithSeachGoods:dic];
}

//获得搜索后的商品
-(void)postWithSeachGoods:(NSDictionary*)dic
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KMyShopGetShopgoods parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *textArr = [NSMutableArray new];
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if([errcode isEqualToString:@"12366"])
        {
            for (NSDictionary *textdic in responseObject[@"errmsg"]) {
                ShopGoodsModel *model = [ShopGoodsModel new];
                [model setValuesForKeysWithDictionary:textdic];
                [textArr addObject:model];
            }
            _tableArr = [NSArray arrayWithArray:textArr];
            if (_tableArr.count == 20) {
                _i = 2;
                _tableView.mj_footer.hidden = NO;
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"page":[NSString stringWithFormat:@"%ld",_i]};
                    [self postWithNextGoods:dic];
                }];
            }else
            {
                _tableView.mj_footer.hidden = YES;
            }
            _tableView.frame = CGRectMake(0, _collectionView2.frame.origin.y+_collectionView2.frame.size.height, kWidth, 582);
            _scrollView.contentSize = CGSizeMake(kWidth, _tableView.frame.size.height+_collectionView1.frame.size.height+_collectionView2.frame.size.height);
            [_tableView reloadData];
        }else if([errcode isEqualToString:@"12356"])
        {
            _tableArr = [NSArray new];
            _tableView.mj_footer.hidden = YES;
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postWithSeachGoods:dic];
    }];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.isShowTab =YES;
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
