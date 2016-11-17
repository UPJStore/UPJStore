//
//  DealerDetailViewController.m
//  UPJStore
//
//  Created by upj on 16/9/28.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "DealerDetailViewController.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"
#import "AFNetWorking.h"
#import "DealerDetailTableViewCell.h"
#import "BranchDetailModel.h"

@interface DealerDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *storeView;
@property(nonatomic,strong)NSArray *listArr;
@property(nonatomic,strong)NSArray *orderArr;
@property(nonatomic,strong)NSDictionary *incomeDic;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation DealerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.title = @"店铺详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    _listArr = [NSArray new];
    _orderArr = [NSArray new];
    _incomeDic = [NSDictionary new];
    [self postWithData];
}

-(void)postWithData
{
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer ];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * dic =@{@"appkey":APPkey,@"member_id":_model.member_id,@"domain_level":_domain_level,@"level":_level};
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KBranchOrderDetail parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if ([errcode isEqualToString:@"12367"]) {
            _listArr = [NSArray new];
            _orderArr = [NSArray new];
            _incomeDic = [NSDictionary new];
        }else if([errcode isEqualToString:@"12368"])
        {
            NSDictionary *textlistdic = [NSDictionary dictionaryWithDictionary:responseObject[@"errmsg"][@"order_detail"]];
            NSArray *keyArr1 =[NSArray arrayWithArray:textlistdic.allKeys];
            _orderArr = [NSArray arrayWithArray:keyArr1];
            NSMutableArray *slistArr = [[NSMutableArray alloc]init];
            for (NSString *key in keyArr1) {
                NSArray *goodsArr = textlistdic[key];
                NSMutableArray *sgoodsArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in goodsArr) {
                    BranchDetailModel *model = [BranchDetailModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [sgoodsArr addObject:model];
                }
                [slistArr addObject:sgoodsArr];
            }
            _listArr = [NSArray arrayWithArray:slistArr];
            
            NSDictionary *textincomedic = [NSDictionary dictionaryWithDictionary:responseObject[@"errmsg"][@"order_income"]];
            _incomeDic = [NSDictionary dictionaryWithDictionary:textincomedic];
        }
        [self initWithStoreView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"errer %@",error);
    }];
}

-(void)initWithStoreView
{
    _storeView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 110)];
    _storeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_storeView];
    //头像
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(20, 15, 80, 80)];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.layer.cornerRadius = CGFloatMakeY(7);
    imageView.layer.borderColor = [UIColor colorFromHexRGB:@"b7b7bf"].CGColor;
    imageView.layer.borderWidth = 0.5;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    [_storeView addSubview:imageView];
    
    UILabel *nameLablel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 15, 300, 20)];
    nameLablel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    if (_model.shop_name.length == 0) {
        nameLablel.text = [NSString stringWithFormat:@"分店名:%@",_model.shop_name];
    }else{
        nameLablel.text = [NSString stringWithFormat:@"分店名:%@的店铺",_model.nickname];
    }
    nameLablel.textColor = [UIColor blackColor];
    [_storeView addSubview:nameLablel];
    
    UILabel *WXnameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 35, 300, 20)];
    WXnameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    WXnameLabel.text = [NSString stringWithFormat:@"分店微信:%@",_model.nickname];
    WXnameLabel.textColor = [UIColor colorFromHexRGB:@"b7b7bf"];
    [_storeView addSubview:WXnameLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 55, 300, 20)];
    moneyLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    moneyLabel.text = [NSString stringWithFormat:@"营业额:%@",_model.income];
    moneyLabel.textColor = [UIColor colorFromHexRGB:@"b7b7bf"];
    [_storeView addSubview:moneyLabel];
    
    UILabel *recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake1(110, 75, 300, 20)];
    recommendLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    recommendLabel.text = [NSString stringWithFormat:@"推荐人:%@",_model.tui];
    recommendLabel.textColor = [UIColor colorFromHexRGB:@"b7b7bf"];
    [_storeView addSubview:recommendLabel];
    
    [self initWithTableView];
}

-(void)initWithTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,_storeView.frame.size.height, kWidth, kHeight-_storeView.frame.size.height-64) style:UITableViewStylePlain];
    [_tableView registerClass:[DealerDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"none"];
    _tableView.backgroundColor  = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
   // _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
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
    if (_listArr.count != 0) {
        NSArray *arr =[NSArray arrayWithArray:_listArr[indexPath.row]];
        return CGFloatMakeY(80)+CGFloatMakeY(40)*arr.count;
    }else
    {
        return CGFloatMakeY(40);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listArr.count != 0) {
        DealerDetailTableViewCell *cell = [[DealerDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.arr = [NSArray arrayWithArray:_listArr[indexPath.row]];
        cell.ordersn = [NSString stringWithFormat:@"%@",_orderArr[indexPath.row]];
        cell.allincome = [NSString stringWithFormat:@"%@",_incomeDic[cell.ordersn]];
        [cell cellreloate];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
          _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return cell;
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none" forIndexPath:indexPath];
        cell.textLabel.textAlignment = 1;
        cell.textLabel.text = @"暂无任何订单";
        cell.textLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 10)];
    view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    return view;
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
