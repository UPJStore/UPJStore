//
//  SelectPayMethohViewController.m
//  UPJStore
//
//  Created by upj on 16/4/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//



#import "SelectPayMethohViewController.h"
#import "SelectTableViewCell.h"
#import "PaySuccessViewController.h"
#import "AFNetworking.h"
#import "UIViewController+CG.h"
// 微信
#import "WXApi.h"
// 支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import "UIColor+HexRGB.h"

@interface SelectPayMethohViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *selectPayTabelView;
@property (nonatomic,strong)UIView *orderInfoView;
@property (nonatomic,strong)UIButton *surePayBtn;
@property (nonatomic,strong)NSString *record;
@property (nonatomic,strong)UILabel *orderTotal;
@property (nonatomic)NSInteger z;

@end

@implementation SelectPayMethohViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付订单";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlePayResult:) name:WX_PAY_RESULT object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor =  [UIColor lightGrayColor];
    
    [self initOrderInfoView];
    [self initTableView];
    [self initSurePayBtn];
    // Do any additional setup after loading the view.
}
-(void)pop{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    if ([_record isEqualToString:@"backToRoot"]) {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //        _record = nil;
    //    }
}
-(void)initOrderInfoView{
    
    self.orderInfoView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414,80)];
    self.orderInfoView.backgroundColor = [UIColor whiteColor];
    self.orderInfoView.layer.borderWidth = 1;
    self.orderInfoView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 10, 394, 30)];
    orderLabel.text = [NSString stringWithFormat:@"订单详情 : %@",self.orderID];
    orderLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    orderLabel.textColor = [UIColor colorFromHexRGB:@"666666"];
    _orderTotal = [[UILabel alloc]initWithFrame:CGRectMake1(10, 40, 394, 30)];
    _orderTotal.text = [NSString stringWithFormat:@"总价格 : %@",self.totalPrice];
    _orderTotal.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    _orderTotal.textColor = [UIColor colorFromHexRGB:@"666666"];
    
    [self.view addSubview:self.orderInfoView];
    [self.view addSubview:orderLabel];
    [self.view addSubview:_orderTotal];
    
}
-(void)initSurePayBtn{
    self.surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.surePayBtn.frame = CGRectMake(20, self.view.bounds.size.height-130, self.view.bounds.size.width-40,50);
    self.surePayBtn.layer.cornerRadius = 10;
    self.surePayBtn.clipsToBounds = YES;
    [self.surePayBtn setBackgroundColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1]];
    [self.surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.surePayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.surePayBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.surePayBtn];
}
#pragma mark -- tableview
-(void)initTableView{
    self.selectPayTabelView = [[UITableView alloc]initWithFrame:CGRectMake1(0,100,414,170) style:UITableViewStylePlain];
    self.selectPayTabelView.scrollEnabled = NO;
    self.selectPayTabelView.delegate = self;
    self.selectPayTabelView.dataSource = self;
    [self.selectPayTabelView registerClass:[SelectTableViewCell class] forCellReuseIdentifier:@"reuseCell"];
    [self.selectPayTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"titleCell"];
    [self.view addSubview:self.selectPayTabelView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectTableViewCell *cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseCell"];
    
    if (indexPath.row == 0) {
        cell.payLabel.text = @"微信支付";
        cell.selectLogo.image = [UIImage imageNamed:@"绿色logo"];
        [cell.sureBtn setTag:11];
    }else if (indexPath.row == 1) {
        cell.payLabel.text = @"支付宝支付";
        cell.selectLogo.image = [UIImage imageNamed:@"biao"];
        [cell.sureBtn setTag:22];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGFloatMakeY(60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     UIButton *wechatPayBtn = (UIButton *)[self.view viewWithTag:11];
     UIButton *AliPayBtn = (UIButton *)[self.view viewWithTag:22];
     if (indexPath.row == 0) {
         wechatPayBtn.selected = YES;
         AliPayBtn.selected = NO;
     }
    if (indexPath.row == 1) {
        AliPayBtn.selected = YES;
        wechatPayBtn.selected = NO;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFloatMakeY(50);
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-10, 50)];
        headerLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        headerLabel.text = @"请选择支付方式";
        [headerView addSubview:headerLabel];
        return headerView;
    }
    return nil;
}

-(void)payAction{
      UIButton *wechatPay = (UIButton *)[self.view viewWithTag:11];
      UIButton *AliPay = (UIButton *)[self.view viewWithTag:22];
    if (wechatPay.isSelected) {
        DLog(@"微信支付");
        if([WXApi isWXAppInstalled]){
            [self goToWeCHatBuy];
        }else{
            [self setupAlertController];
        }
    }else if (AliPay.isSelected){
        DLog(@"支付宝支付");
        [self goToAlipay];
    }
}
#pragma mark -- 微信支付
-(void)goToWeCHatBuy{
    
    NSDictionary * dic =@{@"appkey":APPkey,@"mid":[self returnMid],@"id":self.orderID};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager POST:KPay parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        NSDictionary *dic = responseObject[@"data"];
        
        NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
        //调起支付
        PayReq *req = [[PayReq alloc]init];
        req.partnerId = dic[@"partnerid"];//@"10000100";//商家id
        req.prepayId = dic[@"prepayid"];//@"wx20160222181228eabc76df380849802454";//预支付订单
        req.package = dic[@"package"];  //@"Sign=WXPay";//扩展字段  暂填写固定值Sign=WXPay
        req.nonceStr = dic[@"noncestr"];//@"758d476b9ebdc37e698ccfbdbcd21906";//随机串，防重发
        req.timeStamp = stamp.intValue; //@"1456135948";//时间戳
        req.sign = dic[@"sign"];//@"61EC78AB39E256B2624D54C7E1390D70";//商家根据微信开放平台文档对数据做的签名
        [WXApi sendReq:req];
        
        DLog(@"\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error : %@",error);
        
    }];
}
- (void)handlePayResult:(NSNotification *)noti{
    DLog(@"Notifiction Object : %@",noti.object);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"支付结果" message:[NSString stringWithFormat:@"%@",noti.object] preferredStyle:UIAlertControllerStyleActionSheet];
    if ([noti.object isEqualToString:@"成功"]) {
        PaySuccessViewController *success = [[PaySuccessViewController alloc]init];
        success.orderId = self.orderID;
        [self.navigationController pushViewController:success animated:YES];
    }
    else
    {
        //添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"重新支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goToWeCHatBuy];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- 支付宝支付
-(void)goToAlipay{
    NSDictionary *dic = @{@"appkey":APPkey,@"id":self.orderID,@"mid":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    AFHTTPSessionManager * manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:kAlipay parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        
        NSString *partner = ALIPAY_PARTNER;  //支付宝商户id-账号id
        NSString *seller = ALIPAY_SELLER;
        NSString *privateKey = ALIPAY_PRIVATEKEY;  //私钥
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order *order = [[Order alloc] init];
        order.partner = partner;
        order.seller = seller;
        order.tradeNO = responseObject[@"out_trade_no"]; //订单ID（由商家自行制定）
        order.productName = responseObject[@"subject"]; //商品标题
        order.productDescription = responseObject[@"subject"]; //商品描述
        order.amount = responseObject[@"total_fee"]; //商品价格
        order.notifyURL =  responseObject[@"notify_url"]; //回调URL
        
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
        DLog(@"%@",order);
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"AlipayProject";
        //需要和URL Types统一
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                //【callback处理支付结果】
                DLog(@"reslut = %@",resultDic);
                _record = @"backToRoot";
                if ([resultDic[@"resultStatus"]isEqualToString:@"6001"]) {
                    DLog(@"取消支付");
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"支付结果" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                    //添加按钮
                    [alert addAction:[UIAlertAction actionWithTitle:@"重新支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self goToAlipay];
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]){
                    DLog(@"支付成功");
                    PaySuccessViewController *success = [[PaySuccessViewController alloc]init];
                    success.orderId = self.orderID;
                    [self.navigationController pushViewController:success animated:YES];
                }
                
                
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog("%@",error);
        
    }];
    
    
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
