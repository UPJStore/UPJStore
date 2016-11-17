//
//  CommissonDetailViewController.m
//  UPJStore
//
//  Created by upj on 16/10/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CommissonDetailViewController.h"
#import "UIViewController+CG.h"
#import "CommissionDetailModel.h"
#import "CommissionDetailTableViewCell.h"

@interface CommissonDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *moneyView;
@property(nonatomic,strong)UILabel *moneyLabel1;
@property(nonatomic,strong)UILabel *moneyLabel2;
@property(nonatomic,strong)UIView *detailView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *drawalBtn;
@property(nonatomic,strong)NSArray *tableArr;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation CommissonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorFromHexRGB:@"f6f6f6"];
    if (_isFlag) {
        self.navigationItem.title = @"佣金明细";
    }else
    {
        self.navigationItem.title = @"利润明细";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    _tableArr = [NSArray new];
    [self postdataWithData];
}

-(void)initWithheaderView
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
    
    [self initWithView];
}

-(void)initWithView
{
    _moneyView = [[UIView alloc]initWithFrame:CGRectMake1(0, 157, 414, 40)];
    _moneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moneyView];
    
    UIImageView *Img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CK2"]];
    Img1.frame = CGRectMake1(20, 12, 16, 16);
    [_moneyView addSubview:Img1];
    
    _moneyLabel1 = [[UILabel alloc]initWithFrame:CGRectMake1(45, 0,300, 40)];
    if (_isFlag) {
        _moneyLabel1.text = [NSString stringWithFormat:@"可提现佣金金额 ：%@",_str];
    }else
    {
        _moneyLabel1.text = [NSString stringWithFormat:@"可提现利润金额 ：%@",_str];
    }
    _moneyLabel1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_moneyView addSubview:_moneyLabel1];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 39.5, 414, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [_moneyView addSubview:lineView];
    
    
     _drawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     _drawalBtn.frame = CGRectMake1(354, 7, 50, 26);
     _drawalBtn.layer.cornerRadius = CGFloatMakeY(5);
     _drawalBtn.backgroundColor = [UIColor redColor];
     [_drawalBtn setTitle:@"提现" forState:UIControlStateNormal];
     [_drawalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     _drawalBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_drawalBtn addTarget:self action:@selector(drawalBtnAction) forControlEvents:UIControlEventTouchUpInside];
     [_moneyView addSubview:_drawalBtn];
     
    
    [self initWithTableView];
}

-(void)initWithTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _moneyView.frame.origin.y+_moneyView.frame.size.height, kWidth, kHeight-(_moneyView.frame.origin.y+_moneyView.frame.size.height)-CGFloatMakeY(64)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[CommissionDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"none"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableArr.count != 0) {
        return _tableArr.count;
    }else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableArr.count != 0) {
        CommissionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        CommissionDetailModel *model = _tableArr[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 60)];
        label.text = @"暂无提现记录";
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        label.textAlignment = 1;
        [cell addSubview:label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)postdataWithData
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KGetCarryHistory parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if ([errcode isEqualToString:@"10236"]) {
            NSDictionary *errdic = [NSDictionary dictionaryWithDictionary:responseObject[@"errmsg"]];
            NSArray *textarr = [NSArray arrayWithArray:errdic[@"result"]];
            NSMutableArray *saveArr = [NSMutableArray new];
            for (NSDictionary *dic  in textarr) {
                CommissionDetailModel *model = [CommissionDetailModel new];
                [model setValuesForKeysWithDictionary:dic];
                [saveArr addObject:model];
            }
            _tableArr = [NSArray arrayWithArray:saveArr];
        }else
        {
            _tableArr = [NSArray new];
        }
        [self initWithheaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postdataWithData];
    }];
}

-(void)drawalBtnAction
{
    _drawalBtn.userInteractionEnabled = NO;
    [self postDataWithComapply];
}

-(void)postDataWithComapply
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"member_id":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KShopComapply parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        _drawalBtn.userInteractionEnabled = YES;
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if ([errcode isEqualToString:@"10238"]) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hide) userInfo:nil repeats:NO];
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"无可提现订单" preferredStyle:UIAlertControllerStyleAlert];
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"无可提现订单"];
            [hogan addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                          range:NSMakeRange(0, 6)];
            [alertCon setValue:hogan forKey:@"attributedMessage"];
            [self presentViewController:alertCon animated:YES completion:nil];
        }else if([errcode isEqualToString:@"10236"])
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hide) userInfo:nil repeats:NO];
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"申请提现成功" preferredStyle:UIAlertControllerStyleAlert];
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"申请提现成功"];
            [hogan addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                          range:NSMakeRange(0, 6)];
            [alertCon setValue:hogan forKey:@"attributedMessage"];
            [self presentViewController:alertCon animated:YES completion:nil];
            [self postShopdatawithshop];
        }else if([errcode isEqualToString:@"10237"])
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hide) userInfo:nil repeats:NO];
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"申请提现失败" preferredStyle:UIAlertControllerStyleAlert];
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"申请提现失败"];
            [hogan addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                          range:NSMakeRange(0, 6)];
            [alertCon setValue:hogan forKey:@"attributedMessage"];
            [self presentViewController:alertCon animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
       // [self postDataWithComapply];
    }];
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
            _moneyLabel1.text = [NSString stringWithFormat:@"可提现利润金额 ：%@",str1];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}



-(void)hide
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [_timer invalidate];
    _timer = nil;
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
