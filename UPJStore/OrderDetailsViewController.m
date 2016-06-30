//
//  OrderDetailsViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "AFNetworking.h"
#import "UIViewController+CG.h"
#import "CommodModel.h"
#import "EvaluateViewController.h"
#import "CommodView.h"
#import "MBProgressHUD.h"
#import "UIColor+HexRGB.h"
#import "SelectPayMethohViewController.h"
#import "GoodSDetailViewController.h"

@interface OrderDetailsViewController ()
{
    NSString *statuStr;
    NSString *button1Str;
    NSString *button2Str;
    UIScrollView *scrollView;
    UIButton *button1;
    UIButton *button2;
    UIView *btnView;
    NSTimer *timer;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    //  UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    self.navigationItem.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = backcolor;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake1(0, 0, 414, 600)];
    [self.view addSubview:scrollView];
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 110)];
    redView.backgroundColor = btncolor;
    [scrollView addSubview:redView];
    
    [self buttonActionwith:_model.status.integerValue];
    
    UILabel* stateslabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 20, 364, 20)];
    stateslabel.text = [NSString stringWithFormat:@"订单状态：%@",statuStr];
    stateslabel.textAlignment = 0;
    stateslabel.textColor = [UIColor whiteColor];
    stateslabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [redView addSubview:stateslabel];
    
    UILabel *ordersnlabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 60, 364, 20)];
    ordersnlabel.text = [NSString stringWithFormat:@"订单号：%@",self.model.ordersn];
    ordersnlabel.textAlignment = 0;
    ordersnlabel.textColor = [UIColor whiteColor];
    ordersnlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [redView addSubview:ordersnlabel];
    
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake1(0, 120, 414, 80)];
    addressView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:addressView];
    
    UILabel *consigneeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 15, 250, 15)];
    consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@",self.model.consignee];
    consigneeLabel.textAlignment = 0;
    consigneeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    consigneeLabel.textColor = textcolor;
    [addressView addSubview:consigneeLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake1(300, 15, 114, 15)];
    phoneLabel.text = self.model.mobile;
    phoneLabel.textAlignment = 0;
    phoneLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    phoneLabel.textColor = textcolor;
    [addressView addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 35, 364, 40)];
    addressLabel.text = [NSString stringWithFormat:@"收货地址:%@%@%@%@",_model.province,_model.city,_model.area,_model.address];
    addressLabel.textColor = textcolor;
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [addressView addSubview:addressLabel];
    
    UIView *commodityView = [[UIView alloc]initWithFrame:CGRectMake1(0, 210, 414, 100*_model.goodArr.count)];
    commodityView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:commodityView];
    
    for (int i = 0; i<_model.goodArr.count; i++) {
        CommodView *commodView = [[CommodView alloc]initWithFrame:CGRectMake1(0, 100*i, 414, 100)];
        CommodModel *commodmodel = _model.goodArr[i];
        commodView.nameLabel.text = commodmodel.title;
        commodView.moneylabel.text = [@"¥" stringByAppendingString:commodmodel.marketprice];
        commodView.numberlabel.text = [NSString stringWithFormat:@"共%@件",commodmodel.total];
        commodView.button.tag = i;
        [commodView.goodDetailBtn addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
        commodView.goodDetailBtn.tag = [commodmodel.aid integerValue];
        [commodView.button addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:commodmodel.thumb]]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame  = CGRectMake1(10, 10, 85, 85);
        [imageView.layer setBorderWidth:0.5];
        [imageView.layer setCornerRadius:5];
        [imageView.layer setBorderColor:[UIColor colorFromHexRGB:@"e9e9e9"].CGColor];
        [commodView addSubview:imageView];
        
        [commodityView addSubview:commodView];

        if (!self.isEvaluate) {
            commodView.button.hidden = YES;
        }
    }
    //
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake1(0, 220+_model.goodArr.count*100, 414, 250)];
    moneyView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:moneyView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 0, 404, 40)];
    label1.textColor = textcolor;
    label1.textAlignment = 0;
    label1.text = @"结算";
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 39.5, 414, 0.5)];
    line1.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
    [moneyView addSubview:line1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 40, 404, 40)];
    label2.textColor = textcolor;
    label2.textAlignment = 0;
    label2.text = @"商品总额";
    label2.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label2];
    
    UILabel *label22 = [[UILabel alloc]initWithFrame:CGRectMake1(300, 40, 104, 40)];
    label22.text = [NSString stringWithFormat:@"¥%@",_model.goodsprice];
    label22.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    label22.textAlignment =2;
    [moneyView addSubview:label22];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 79.5, 414, 0.5)];
    line2.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
    [moneyView addSubview:line2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 80, 404, 40)];
    label3.textColor = textcolor;
    label3.textAlignment = 0;
    label3.text = @"物流费用";
    label3.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label3];
    
    UILabel *label33 = [[UILabel alloc]initWithFrame:CGRectMake1(300, 80, 104, 40)];
    label33.text = [NSString stringWithFormat:@"¥%@",_model.dispatchprice];
    label33.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    label33.textAlignment =2;
    [moneyView addSubview:label33];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake1(0, 119.5, 414, 0.5)];
    line3.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
    [moneyView addSubview:line3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 120, 404, 40)];
    label4.textColor = textcolor;
    label4.textAlignment = 0;
    label4.text = @"关税";
    label4.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label4];
    
    UILabel *label44 = [[UILabel alloc]initWithFrame:CGRectMake1(300, 120, 104, 40)];
    label44.text = @"¥0.00";
    label44.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    label44.textAlignment =2;
    [moneyView addSubview:label44];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake1(0, 159.5, 414, 0.5)];
    line4.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
    [moneyView addSubview:line4];
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake1(0, 160, 404, 40)];
    label5.textColor = textcolor;
    float mf = _model.goodsprice.floatValue+_model.dispatchprice.floatValue+0;
    NSString *allprice = [NSString stringWithFormat:@"应付总额：¥%.2f",mf];
    NSRange rang1 = NSMakeRange(5, allprice.length -5);
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:allprice];
    [aStr addAttribute:NSForegroundColorAttributeName value:btncolor range:rang1];
    label5.attributedText = aStr;
    label5.textAlignment = 2;
    label5.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label5];
    
    UILabel *label55 = [[UILabel alloc]initWithFrame:CGRectMake1(0, 200, 404, 40)];
    label55.textAlignment = 2;
    NSString *tStr = [self timeWithcuo:_model.createtime];
    label55.text = [NSString stringWithFormat:@"下单时间：%@",tStr];
    label55.textAlignment = 2;
    label55.textColor = textcolor;
    label55.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label55];
    //
    //   UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake1(0, 279.5, 414, 0.5)];
    //  line5.backgroundColor = textcolor;
    // [moneyView addSubview:line5];
    scrollView.contentSize = CGSizeMake1(414, 450+_model.goodArr.count*100);
    scrollView.showsVerticalScrollIndicator = NO;
    
    btnView = [[UIView alloc]initWithFrame:CGRectMake1(0, 600, 414, 72)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake1(230, 25, 80, 25);
    [button1 setTitle:button1Str forState:UIControlStateNormal];
    [button1 setTitleColor:textcolor forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    button1.layer.borderWidth = 0.5;
    button1.layer.borderColor = textcolor.CGColor;
    [button1.layer setCornerRadius:5];
    [btnView addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake1(320, 25, 80, 25);
    [button2 setTitle:button2Str forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [button2.layer setCornerRadius:5];
    button2.backgroundColor = btncolor;
    button2.layer.borderColor = textcolor.CGColor;
    [btnView addSubview:button2];
    
    if ([button1Str isEqualToString:@"0"]) {
        button1.hidden = YES;
    }
    if ([button2Str isEqualToString:@"0"]) {
        button2.hidden = YES;
    }
    [self buttonActionwith:_model.status.integerValue];
}

-(void)goToDetail:(UIButton *)btn
{
    GoodSDetailViewController *goodVC = [[GoodSDetailViewController alloc]init];
    
    
    NSDictionary * dic = @{@"appkey":APPkey,@"id":[NSString stringWithFormat:@"%ld",btn.tag]};
    
    goodVC.goodsDic = dic;
    //    goodVC.isFromHomePage = YES;
    
    [self.navigationController pushViewController:goodVC animated:NO];
}

-(void)buttonActionwith:(NSInteger)number
{
    switch (number) {
        case 0:
            statuStr = @"待付款";
            button1Str = @"取消订单";
            button2Str = @"立即付款";
            [button1 addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.hidden = NO;
            scrollView.frame = CGRectMake1(0, 0, 414, 600);
            break;
        case 1:
            statuStr = @"待发货";
            button1Str = @"0";
            button2Str = @"提醒发货";
            [button2 addTarget:self action:@selector(remindAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.hidden = NO;
            scrollView.frame = CGRectMake1(0, 0, 414, 600);
            break;
        case 2:
            statuStr = @"待收货";
            button1Str = @"0";
            button2Str = @"确认收货";
            [button2 addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.hidden = NO;
            scrollView.frame = CGRectMake1(0, 0, 414, 600);
            break;
        case 3:
            statuStr = @"已完成";
            button1Str = @"0";
            button2Str = @"评价";
            //     [button2 addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.hidden = YES;
            scrollView.frame = CGRectMake1(0, 0, 414, 672);
            break;
        case -1:
            statuStr = @"已关闭";
            button1Str = @"0";
            button2Str = @"0";
            btnView.hidden = YES;
            break;
        case -2:
            statuStr = @"退款中";
            button1Str = @"0";
            button2Str = @"0";
            btnView.hidden = YES;
            break;
        case -3:
            statuStr = @"换货中";
            button1Str = @"0";
            button2Str = @"0";
            btnView.hidden = YES;
            break;
        case -4:
            statuStr = @"退货中";
            button1Str = @"0";
            button2Str = @"0";
            btnView.hidden = YES;
            break;
        case -5:
            statuStr = @"已退货";
            button1Str = @"0";
            button2Str = @"0";
            btnView.hidden = YES;
            break;
        case -6:
            statuStr = @"已退款";
            button1Str = @"0";
            button2Str = @"0";
            btnView.hidden = YES;
            break;
    }
}

-(void)payAction:(UIButton*)btn
{
    [self setMBHUD];
    SelectPayMethohViewController *selectVC = [[SelectPayMethohViewController alloc]init];
    selectVC.orderID = _model.orderid;
    selectVC.totalPrice = _model.goodsprice;
    [self.navigationController pushViewController:selectVC animated:YES];
}


-(void)cancelAction:(UIButton*)btn
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"确定收到货物？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setMBHUD];
        NSDictionary *dic = @{@"appkey":APPkey,@"mid":_mid,@"id":_model.orderid};
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    //发送请求
    [manager POST:kCancel parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
        [self pop];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)remindAction:(UIButton*)btn
{
    [self setMBHUD];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":_mid,@"id":_model.orderid};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    //发送请求
    [manager POST:kRemind parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"已提醒发货" preferredStyle:UIAlertControllerStyleAlert];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3  target:self selector:@selector(hide) userInfo:nil repeats:NO];
        [self presentViewController:alertCon animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)hide
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
    timer = nil;
}

-(void)confirmAction:(UIButton*)button
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"确定收到货物？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setMBHUD];
        NSDictionary *dic = @{@"appkey":APPkey,@"mid":_mid,@"id":_model.orderid,@"status":@"3"};
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    //发送请求
    [manager POST:kUpdata parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
        [self pop];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(NSString *)timeWithcuo:(NSString*)cuo
{
    NSTimeInterval time=[cuo doubleValue];
    //+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate: detaildate];
}

-(void)evaluateAction:(UIButton*)btn
{
    EvaluateViewController *EVC = [EvaluateViewController new];
    EVC.model = self.model;
    EVC.Sequence = btn.tag;
    EVC.number = 1;
    [self.navigationController pushViewController:EVC animated:YES];
}

#pragma mark -- 加载动画
-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:scrollView animated:YES];
    // Set the custom view mode to show any view.
    /*
     _loadingHud.mode = MBProgressHUDModeCustomView;
     UIImage *gif = [UIImage sd_animatedGIFNamed:@"youpinji"];
     
     UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
     _loadingHud.customView = gifView;
     */
    _loadingHud.bezelView.backgroundColor = [UIColor clearColor];
    _loadingHud.animationType = MBProgressHUDAnimationFade;
    _loadingHud.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
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
