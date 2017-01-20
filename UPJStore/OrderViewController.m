//
//  OrderViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderModel.h"
#import "OrderTableViewCell.h"
#import "UIViewController+CG.h"
#import "OrderDetailsViewController.h"
#import "EvaluateViewController.h"
#import "SelectPayMethohViewController.h"
#import "OrderBtn.h"
#import "MJRefresh.h"

#define widthSize 414.0/320
#define hightSize 736.0/568

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *lineView;
    UIView *lineView2;
    UIView *redLineView;
    NSArray *jsonArr;
    NSMutableArray *dataArr;
    UITableView *orderTableView;
    UIColor *btncolor;
    UIColor *fontcolor;
    NSString *statuStr;
    NSString *button1Str;
    NSString *button2Str;
    BOOL isEvaluate;
    UIImageView *imageView;
    UILabel *label;
    NSTimer *timer;
    NSInteger num;
    BOOL isSelect;
}
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    self.navigationItem.title = @"我的订单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    
    NSArray *arr = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 45)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [headView addSubview:lineView];
    lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 44, 414, 0.5)];
    lineView2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [headView addSubview:lineView2];
    
    for (int i=0; i<5; i++)
    {
        OrderBtn *button = [[OrderBtn alloc]initWithFrame:CGRectMake1(414/5*i, 0, 414/5, 44)];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.tag = i;
        if (i == self.number) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else
        {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderViewlogo"]];
    imageView.frame = CGRectMake1(152, 135, 105, 105);
    [self.view addSubview:imageView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 260, 414, 40)];
    label.text = @"暂无任何订单";
    label.textAlignment = 1;
    label.textColor = textcolor;
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [self.view addSubview:label];
    
    orderTableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 45, 414, 625)style:UITableViewStylePlain];
    [self.view addSubview:orderTableView];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    orderTableView.showsVerticalScrollIndicator = NO;
    [orderTableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"orders"];
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self switchActionWithnumber:self.number];
    [self setMBHUD];
}

-(void)tapAction:(OrderBtn*)btn
{
    if (!isSelect) {
        isSelect = YES;
        [btn didtap];
    if (self.number!= btn.tag) {
        isEvaluate = NO;
        if(btn.tag == 4){
            isEvaluate = YES;
        }
        self.number = btn.tag;
        [self switchActionWithnumber:btn.tag];
        [self setMBHUD];
        orderTableView.userInteractionEnabled = NO;
        [self modelGet];
    }
    }
    
}

-(void)switchActionWithnumber:(NSInteger)number
{
    switch (number) {
        case 0:
        {
            _orderid = @"";
        }
            break;
        case 1:
        {
            _orderid = @"0";
        }
            break;
        case 2:
        {
            _orderid = @"1";
        }
            break;
        case 3:
        {
            _orderid = @"2";
        }
            break;
        case 4:
        {
            _orderid = @"3";
        }
            break;
        default:
            break;
    }
}



-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

//tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel * model1 = dataArr[indexPath.row];
    OrderTableViewCell *cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orders"model:model1 isEvaluate:isEvaluate];
    [self statuStrSwitchWith:model1.status.integerValue Withcell:cell];
    cell.statelabel.text = statuStr;
    [cell buttonGetStrWithbutton1:button1Str button2:button2Str];
    cell.button1.tag = indexPath.row;
    cell.button2.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = dataArr[indexPath.row];
    return CGFloatMakeY(75+100*model.goodArr.count);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = dataArr[indexPath.row];
    OrderDetailsViewController *odvc = [OrderDetailsViewController new];
    odvc.model = model;
    odvc.mid = self.mid;
    odvc.isEvaluate = isEvaluate;
    [self.navigationController pushViewController:odvc animated:YES ];
}



-(void)statuStrSwitchWith:(NSInteger)number Withcell:(OrderTableViewCell*)cell
{
    switch (number) {
        case 0:
            statuStr = @"待付款";
            button1Str = @"取消订单";
            button2Str = @"立即付款";
            [cell.button1 addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.button2 addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.button2.layer setBorderColor:[UIColor redColor].CGColor];
            [cell.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
        case 1:
            statuStr = @"待发货";
            button1Str = @"0";
            button2Str = @"提醒发货";
            [cell.button2 addTarget:self action:@selector(remindAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            statuStr = @"待收货";
            button1Str = @"0";
            button2Str = @"确认收货";
            [cell.button1 addTarget:self action:@selector(expressCheckAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.button2 addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 3:
            statuStr = @"已完成";
            button1Str = @"0";
            button2Str = @"评价";
            [cell.button2 addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case -1:
            statuStr = @"已关闭";
            button1Str = @"0";
            button2Str = @"0";
            break;
        case -2:
            statuStr = @"退款中";
            button1Str = @"0";
            button2Str = @"0";
            break;
        case -3:
            statuStr = @"换货中";
            button1Str = @"0";
            button2Str = @"0";
            break;
        case -4:
            statuStr = @"退货中";
            button1Str = @"0";
            button2Str = @"0";
            break;
        case -5:
            statuStr = @"已退货";
            button1Str = @"0";
            button2Str = @"0";
            break;
        case -6:
            statuStr = @"已退款";
            button1Str = @"0";
            button2Str = @"0";
            break;
        default:
            break;
    }
}

-(void)modelGet
{
    NSOperation *modelQperation = [NSBlockOperation blockOperationWithBlock:^{
        NSDictionary *dic = @{@"appkey":APPkey,@"mid":_mid,@"status":_orderid};
        [self postDataWith:dic];
    }];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:modelQperation];
}

-(void)cancelAction:(UIButton*)btn
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定删除订单？"];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                  range:NSMakeRange(0, 7)];
    [alertCon setValue:hogan forKey:@"attributedMessage"];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setMBHUD];
        orderTableView.userInteractionEnabled = NO;
        OrderModel *model = dataArr[btn.tag];
        NSDictionary *dic = @{@"appkey":APPkey,@"mid":_mid,@"id":model.orderid};
        [self canceldataWith:dic];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCon addAction:noAction];
    [alertCon addAction:yesAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}

-(void)canceldataWith:(NSDictionary*)dic
{
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kCancel parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud =nil;
         UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"订单已经删除" preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"订单已经删除"];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                      range:NSMakeRange(0, 6)];
        [alertCon setValue:hogan forKey:@"attributedMessage"];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3  target:self selector:@selector(hide) userInfo:nil repeats:NO];
        [self presentViewController:alertCon animated:YES completion:nil];
        [self modelGet];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)expressCheckAction:(UIButton*)button
{
    OrderModel *model = dataArr[button.tag];
}

-(void)confirmAction:(UIButton*)button
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定收到货物？"];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                  range:NSMakeRange(0, 7)];
    [alertCon setValue:hogan forKey:@"attributedMessage"];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setMBHUD];
        orderTableView.userInteractionEnabled = NO;
        OrderModel *model = dataArr[button.tag];
        NSDictionary *dic = @{@"appkey":APPkey,@"mid":_mid,@"id":model.orderid,@"status":@"3"};
        [self ConfirmDataWith:dic];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCon addAction:noAction];
    [alertCon addAction:yesAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}

-(void)ConfirmDataWith:(NSDictionary*)dic
{
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kUpdata parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self modelGet];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
    
}


-(void)payAction:(UIButton*)btn
{
    
    [self setMBHUD];
    SelectPayMethohViewController *selectVC = [[SelectPayMethohViewController alloc]init];
    OrderModel *model = dataArr[btn.tag];
    selectVC.orderID = model.orderid;
    selectVC.totalPrice = model.goodsprice;
    [self.navigationController pushViewController:selectVC animated:YES];
}



-(void)remindAction:(UIButton*)btn
{
    [self setMBHUD];
    OrderModel *model = dataArr[btn.tag];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":_mid,@"id":model.orderid};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kRemind parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"已提醒发货"];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                      range:NSMakeRange(0, 5)];
        [alertCon setValue:hogan forKey:@"attributedMessage"];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3  target:self selector:@selector(hide) userInfo:nil repeats:NO];
        [self presentViewController:alertCon animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)evaluateAction:(UIButton*)btn
{
    OrderModel *model = dataArr[btn.tag];
    OrderDetailsViewController *odvc = [OrderDetailsViewController new];
    odvc.model = model;
    odvc.mid = self.mid;
    odvc.isEvaluate = isEvaluate;
    [self.navigationController pushViewController:odvc animated:YES ];
}



-(void)postDataWith:(NSDictionary*)dic
{
    num = 2;
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kMine parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   //     [orderTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud =nil;
        dataArr = [NSMutableArray new];
        orderTableView.userInteractionEnabled = YES;
        if (![responseObject[@"data"] isEqual:[NSNull null]]) {
            jsonArr = [NSArray arrayWithArray:responseObject[@"data"]];
            //加入判断。假如超过20个，就添加mjfoot.
            if (jsonArr.count==20) {
                orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postDataWithPage)];
            }
            for (NSDictionary *dic in jsonArr) {
                OrderModel *model = [OrderModel new];
                [model setValuesForKeysWithDictionary:dic];
                [dataArr addObject:model];
            }
            imageView.hidden = YES;
            label.hidden = YES;
            orderTableView.hidden = NO;
            [orderTableView reloadData];
            
        }
        else
        {
            imageView.hidden = NO;
            label.hidden = NO;
            orderTableView.hidden = YES;
        }
        isSelect  = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        
    }];
}

-(void)postDataWithPage
{
    NSDictionary * dic = @{@"appkey":APPkey,@"mid":_mid,@"status":_orderid,@"page":[NSString stringWithFormat:@"%ld",(long)num]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kMine parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        if (![responseObject[@"data"] isEqual:[NSNull null]]) {
            jsonArr = [NSArray arrayWithArray:responseObject[@"data"]];
            if (jsonArr.count == 20) {
                num++;
                orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postDataWithPage)];
            }else
            {
                orderTableView.mj_footer.hidden = YES;
            }
            for (NSDictionary *dic in jsonArr) {
                OrderModel *model = [OrderModel new];
                [model setValuesForKeysWithDictionary:dic];
                [dataArr addObject:model];
            }
            NSLog(@"%ld",(unsigned long)dataArr.count);
            [orderTableView reloadData];
        }else
        {
           orderTableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postDataWithPage];
    }];
}



-(void)hide
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    self.navigationController.navigationBar.translucent = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [self switchActionWithnumber:self.number];
    [self modelGet];
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
