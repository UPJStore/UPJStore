//
//  CommissonWithdrawalViewController.m
//  UPJStore
//
//  Created by upj on 16/9/20.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CommissonWithdrawalViewController.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"
#import "CommissonTableViewCell.h"
#import "AFNetWorking.h"
#import "MJRefresh.h"
#import "CommissionModel.h"
#import "CommissonDetailViewController.h"

@interface CommissonWithdrawalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *drawalView;
@property(nonatomic,strong)UIView *redlineView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *noneView;
@property(nonatomic,strong)NSMutableArray *sumArr;
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,strong)NSMutableDictionary *selectedIndexes;
@property(nonatomic,strong)NSMutableDictionary *goodscount;
@property(nonatomic)NSInteger i;
@property(nonatomic,strong)NSString *status;
@property(nonatomic)BOOL isfirst;
@property(nonatomic,strong)NSString *urlStr1;
@property(nonatomic,strong)NSString *urlStr2;
@property(nonatomic,strong)NSString *urlStr3;
@end

@implementation CommissonWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    _isfirst = YES;
    _i = 2;
    _status = @"0";
    _sumArr = [[NSMutableArray alloc]init];
    _listArr = [[NSMutableArray alloc]init];
    _selectedIndexes = [[NSMutableDictionary alloc]init];
    _goodscount = [[NSMutableDictionary alloc]init];
    if (_isFlag) {
        self.navigationItem.title = @"佣金提现";
        _urlStr1 = KCommission_sum;
        _urlStr2= KCommission_list;
        _urlStr3 = KCommission_goods;
        [self postdatawithmid];
    }else
    {
        self.navigationItem.title = @"利润提现";
        _urlStr1 = KShopCommission_sum;
        _urlStr2 = KShopCommission_list;
        _urlStr3 = KShopCommission_goods;
        [self postShopdatawithshop];
    }
    [self postdatawithstatus];
}

-(void)postShopdatawithshop
{
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"sum_can_commisstion":@"1"};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KGetCanGetList parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if ([errcode isEqualToString:@"10237"]) {
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"errmsg"]];
            NSString *str1 = [NSString stringWithFormat:@"%.2f",str.floatValue];
            [_sumArr addObject:str1];
        }else if([errcode isEqualToString:@"10236"])
        {
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"errmsg"]];
            [_sumArr addObject:str];
        }
        [self postdatawithmid];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)postdatawithmid
{
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"commission_status":@"all"};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:_urlStr1 parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        if (_isFlag) {
            NSString *str1 = responseObject[@"can_cash_commission"][@"sum_commission"];
            if ([str1 isKindOfClass:[NSNull class]]) {
                str1 = @"0.00";
            }
            [_sumArr addObject:str1];
            
            for (int i = 0; i<4; i++) {
                NSString* str2 = [NSString stringWithFormat:@"sum_commission_status_%d",i];
                NSDictionary *dic = responseObject[str2];
                NSString* str3 = dic[@"sum_commission"];
                if ([str3 isKindOfClass:[NSNull class]]) {
                    str3 = @"0.00";
                }
                [_sumArr addObject:str3];
            }
        }else
        {
            for (int i = 0; i<4; i++) {
                NSString *str2 = [NSString stringWithFormat:@"sum_commission_status_%d",i];
                NSString *str3 = responseObject[str2];
                [_sumArr addObject:str3];
            }
        }
        [self initWithHeaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)postdatawithstatus
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"status":_status,@"page":@"1",@"pcount":@"10"};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:_urlStr2 parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.loadingHud hideAnimated:YES];
        self.loadingHud =nil;
        
        DLog(@"%@",responseObject);
        
        //ken test 崩溃修复
        if (![responseObject isKindOfClass:[NSArray class]]) return ;
        NSArray *arr = [NSArray arrayWithArray:responseObject];
        if (arr.count != 0) {
            for (NSDictionary *dic in arr) {
                CommissionModel *model = [CommissionModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_listArr addObject:model];
            }
            if (arr.count == 10) {
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postdatawithpage)];
            }
        }else
        {
            _tableView.mj_footer.hidden = YES;
        }
        if(!_isfirst)
        {
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);

    }];
}

-(void)postdatawithpage
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"status":_status,@"page":[NSString stringWithFormat:@"%ld",_i],@"pcount":@"10"};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:_urlStr2 parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        
        NSArray *arr = [NSArray arrayWithArray:responseObject];
        if (arr.count != 0) {
            for (NSDictionary *dic in arr) {
                CommissionModel *model = [CommissionModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_listArr addObject:model];
            }
            [_tableView reloadData];
            if (arr.count == 10) {
                _i++;
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postdatawithstatus)];
            }else
            {
                _tableView.mj_footer.hidden = YES;
            }
        }else
        {
            _tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        
    }];
}

-(void)postdatawithdic:(NSDictionary*)dic withindexPath:(NSIndexPath* )indexPath
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:_urlStr3 parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *arr = [NSArray arrayWithArray:responseObject];
        [_goodscount setObject:arr forKey:indexPath];
        CommissonTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.arr = arr;
        [cell changewith:[self cellIsSelected:indexPath]];
        [_tableView beginUpdates];
        [_tableView endUpdates];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)initWithHeaderView
{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 147)];
    _headerView.clipsToBounds = YES;
    [self.view addSubview:_headerView];
    
    UIImageView *bgimgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing1.jpg"]];
    bgimgView.frame = CGRectMake1(0, 0,414, 147);
    [_headerView addSubview:bgimgView];
    [_headerView sendSubviewToBack:bgimgView];
    
    UIImageView *photoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headerPhoto"]];
    photoView.frame = CGRectMake1(157, 10, 100, 100);
    photoView.layer.cornerRadius = CGFloatMakeY(45);
    [_headerView addSubview:photoView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(167, 20, 80, 80)];
    imageView.image = [UIImage imageWithData:[self returnImageData]];
    imageView.layer.cornerRadius = CGFloatMakeY(40);
    imageView.clipsToBounds = YES;
    [_headerView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 120, 414, 20)];
    titleLabel.textAlignment = 1;
    titleLabel.text = [self returnNickName];
    titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [_headerView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 146, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [_headerView addSubview:lineView];
    
    [self initWithBtnView];
}

-(void)initWithBtnView
{
    _drawalView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height+CGFloatMakeY(10), kWidth, CGFloatMakeY(100))];
    _drawalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_drawalView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [_headerView addSubview:lineView];
    
    UIImageView *Img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CK2"]];
    Img.frame = CGRectMake1(20, 12, 16, 16);
    [_drawalView addSubview:Img];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(45, 0, 300, 40)];
    if (_isFlag) {
        label.text = [NSString stringWithFormat:@"可提现佣金金额 ：%@",_sumArr[0]];
    }else
    {
        label.text = [NSString stringWithFormat:@"可提现利润金额 ：%@",_sumArr[0]];
    }
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    
    [_drawalView addSubview:label];
    /*
     UIButton *drawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     drawalBtn.frame = CGRectMake1(284, 7, 50, 26);
     drawalBtn.layer.cornerRadius = CGFloatMakeY(5);
     drawalBtn.backgroundColor = [UIColor redColor];
     [drawalBtn setTitle:@"提现" forState:UIControlStateNormal];
     [drawalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     drawalBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
     [_drawalView addSubview:drawalBtn];
     */
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake1(344, 7, 50, 26);
    detailBtn.layer.cornerRadius = CGFloatMakeY(5);
    detailBtn.backgroundColor = [UIColor redColor];
    [detailBtn setTitle:@"明细" forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    if (_isFlag) {
        detailBtn.hidden = YES;
    }
    [_drawalView addSubview:detailBtn];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(10, 39, 394, 1)];
    lineView2.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    [_drawalView addSubview:lineView2];
    
    NSArray *arr =@[@"未付款",@"待发货",@"待收货",@"已完成"];
    
    for (int i = 0; i<4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(414/4*i, 50, 414/4, 20)];
        label.textColor = [UIColor colorFromHexRGB:@"d70626"];
        label.text = _sumArr[i+1];
        label.textAlignment =1;
        label.font = [UIFont boldSystemFontOfSize:CGFloatMakeY(14)];
        [_drawalView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake1(414/4*i, 70, 414/4, 30);
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_drawalView addSubview:btn];
    }
    
    _redlineView = [[UIView alloc]initWithFrame:CGRectMake1(30, 95, 44, 2)];
    _redlineView.backgroundColor = [UIColor colorFromHexRGB:@"d70626"];
    [_drawalView addSubview:_redlineView];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake1(0, 99, 414, 1)];
    lineView3.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    
    [self initWithTableView];
}

-(void)initWithTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _drawalView.frame.origin.y+_drawalView.frame.size.height+CGFloatMakeY(10),kWidth,kHeight-(_drawalView.frame.origin.y+_drawalView.frame.size.height+CGFloatMakeY(10))-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    for (int i = 0;  i < _listArr.count ; i++) {
        NSString *str = [NSString stringWithFormat:@"cell%d",i];
        [_tableView registerClass:[CommissonTableViewCell class] forCellReuseIdentifier:str];
    }
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"none"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

-(void)buttonAction
{
    CommissonDetailViewController *CDVC = [[CommissonDetailViewController alloc]init];
    CDVC.isFlag = _isFlag;
    CDVC.str = _sumArr[0];
    [self.navigationController pushViewController:CDVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listArr.count == 0) {
        return 1;
    }else
    {
        return _listArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self cellIsSelected:indexPath]){
        NSArray *arr = [_goodscount objectForKey:indexPath];
        return CGFloatMakeY(60)+CGFloatMakeY(30)*arr.count;
    }else
    {
        return CGFloatMakeY(60);
    }
}

-(BOOL)cellIsSelected:(NSIndexPath *)indexPath
{
    NSNumber *selectedIndex = [_selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_listArr.count != 0){
        BOOL isSelected = ![self cellIsSelected:indexPath];
        
        NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
        
        CommissionModel *model = _listArr[indexPath.row];
        
        [_selectedIndexes setObject:selectedIndex forKey:indexPath];
        
        if (isSelected) {
            if(_isFlag)
            {
                NSDictionary *dic = @{@"appkey":APPkey,@"orderid":model.orderid};
                [self postdatawithdic:dic withindexPath:indexPath];
            }else
            {
                NSDictionary *dic = @{@"appkey":APPkey,@"orderid":model.orderid,@"level":model.level,@"member_id":[self returnMid],@"createtime":model.createtime};
                [self postdatawithdic:dic withindexPath:indexPath];
            }
        }else
        {
            CommissonTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            [cell changewith:[self cellIsSelected:indexPath]];
            [_tableView beginUpdates];
            [_tableView endUpdates];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listArr.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"];
        }
        UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 60)];
        Label.text = @"暂无订单记录";
        Label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        Label.textAlignment = 1;
        [cell addSubview:Label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else{
        NSString *str = [NSString stringWithFormat:@"cell%ld",indexPath.row];
        CommissonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[CommissonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell changewith:NO];
        CommissionModel *model = _listArr[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.scrollEnabled = YES;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 10)];
    view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    return view;
}


-(void)tapAction:(UIButton*)btn
{
    
    [UIView animateWithDuration:0.35 animations:^{
        _redlineView.frame = CGRectMake1(30+(414/4*btn.tag), 95, 44, 2);
    }];
    if (![_status isEqualToString:[NSString stringWithFormat:@"%ld",(long)btn.tag]]) {
        [self setMBHUD];
        _i = 2;
        _listArr = [NSMutableArray new];
        _selectedIndexes = [NSMutableDictionary new];
        _goodscount = [NSMutableDictionary new];
        _isfirst = NO;
        switch (btn.tag) {
            case 0:
            {
                _status = @"0";
            }
                break;
            case 1:
            {
                _status = @"1";
                
            }
                break;
            case 2:
            {
                _status = @"2";
            }
                break;
            case 3:
            {
                _status = @"3";
            }
                break;
            default:
                break;
        }
        [self postdatawithstatus];
    }
    
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

-(void)setMBHUD{
    self.loadingHud.mode = MBProgressHUDModeAnnularDeterminate;
    self.loadingHud = [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
    // Set the custom view mode to show any view.
    /*
     self.loadingHud.mode = MBProgressHUDModeCustomView;
     UIImage *gif = [UIImage sd_animatedGIFNamed:@"youpinji"];
     
     UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
     self.loadingHud.customView = gifView;
     */
    //    self.loadingHud.bezelView.backgroundColor = [UIColor clearColor];
    //    self.loadingHud.animationType = MBProgressHUDAnimationFade;
    self.loadingHud.backgroundColor = [UIColor whiteColor];
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
