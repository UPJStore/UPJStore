//
//  AppleConfirmViewController.m
//  UPJStore
//
//  Created by upj on 16/10/10.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ApplyConfirmViewController.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"

@interface ApplyConfirmViewController ()
@end

@implementation ApplyConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorFromHexRGB:@"f6f6f6"];
    self.navigationItem.title = @"申请确认";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    
    [self initWithLabel];
}

-(void)initWithLabel
{
    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake1(0, 10, 414, 50)];
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [typeView addSubview:lineView];
    
    UIView *lineView0 = [[UIView alloc]initWithFrame:CGRectMake1(0, 49, 414, 1)];
    lineView0.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [typeView addSubview:lineView0];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 80, 50)];

    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [typeView addSubview:label1];
    
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake1(100, 0, 250, 50)];
    label11.textAlignment = 2;
    label11.textColor = [UIColor colorFromHexRGB:@"aaaaaa"];
    [typeView addSubview:label11];
    
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake1(0, 65, 414, 150)];
    labelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labelView];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(10, 50, 394, 1)];
    lineView2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake1(10, 99, 394, 1)];
    lineView3.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView3];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake1(0, 149, 414, 1)];
    lineView4.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView4];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 80, 50)];
    namelabel.text = @"姓名";
    namelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    namelabel.textAlignment = 0;
    [labelView addSubview:namelabel];
    
    UILabel* nameField = [[UILabel alloc]initWithFrame:CGRectMake1(100, 0, 314, 50)];

    nameField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:nameField];
    
    UILabel *numberlabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 50, 80, 50)];
    numberlabel.textAlignment = 0;
    numberlabel.text = @"手机号码";
    numberlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:numberlabel];
    
    UILabel * numberField = [[UILabel alloc]initWithFrame:CGRectMake1(100, 50, 314, 50)];

    numberField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:numberField];
    
    UILabel *recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 100, 80, 50)];
    recommendLabel.textAlignment = 0;
    recommendLabel.text = @"推荐人";
    recommendLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:recommendLabel];
    
    UILabel* recommendLabel2 = [[UILabel alloc]initWithFrame:CGRectMake1(100, 100, 314, 50)];
    recommendLabel2.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:recommendLabel2];

        label11.text = [NSString stringWithFormat:@"%.0f元",_model.price.floatValue];
        if ([_model.price isEqualToString:@"2000.00"]) {
            label1.text = @"蚂蚁经销商";
            recommendLabel2.text = @"无";
        }else
        {
            label1.text = @"蚂蚁经纪人";
            recommendLabel2.text = @"友品集·全球购商城";
        }
        nameField.text = _model.applyname;
        numberField.text = _model.mobile;
        
    
    
    [self initWithButton];
}

-(void)initWithButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake1(20, 235, 374, 50);
    btn.backgroundColor = [UIColor colorFromHexRGB:@"32a632@"];
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = CGFloatMakeY(8);
    btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btnAction
{
    if([WXApi isWXAppInstalled]){
        [self setMBHUD];
        AFHTTPSessionManager *manager = [self sharedManager];;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        NSDictionary *dic1 = @{@"appkey":APPkey,@"mid":[self returnMid],@"id":_model.order_sn,@"openid":[self returnOpenId],@"shop_apply":@"1",@"shop_upgrade":@"0"};
        
        NSDictionary * Ndic = [self md5DicWith:dic1];
        
        [manager POST:KPay parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
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
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"failure%@",error);
            
        }];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionConfirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
    

}

- (void)handlePayResult:(NSNotification *)noti{
    [self.loadingHud hideAnimated:YES];
    self.loadingHud = nil;
    DLog(@"Notifiction Object : %@",noti.object);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"支付结果" message:[NSString stringWithFormat:@"%@",noti.object] preferredStyle:UIAlertControllerStyleActionSheet];
    if ([noti.object isEqualToString:@"成功"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        //添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"重新支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self btnAction];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}

-(void)pop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.isShowTab =YES;
    [self hideTabBarWithTabState:self.isShowTab];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
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
