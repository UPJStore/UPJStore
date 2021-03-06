//
//  OrderDetailsViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "UIViewController+CG.h"
#import "CommodModel.h"
#import "EvaluateViewController.h"
#import "CommodView.h"
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
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 150)];
    headView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:headView];
    
    [self buttonActionwith:_model.status.integerValue];
    
    UILabel* stateslabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 10, 394, 20)];
    stateslabel.text = [NSString stringWithFormat:@"订单详情：%@",statuStr];
    stateslabel.textAlignment = 0;
    stateslabel.textColor = [UIColor blackColor];
    stateslabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [headView addSubview:stateslabel];
    
    UILabel *ordersnlabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 30, 394, 20)];
    ordersnlabel.text = [NSString stringWithFormat:@"订单号：%@",self.model.ordersn];
    ordersnlabel.textAlignment = 0;
    ordersnlabel.textColor = [UIColor blackColor];
    ordersnlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [headView addSubview:ordersnlabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 50, 394, 20)];
    timeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[self timeWithcuo:_model.createtime]];
    timeLabel.textAlignment = 0;
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [headView addSubview:timeLabel];
    
 //   UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake1(0, 120, 414, 80)];
 //   addressView.backgroundColor = [UIColor whiteColor];
 //   [scrollView addSubview:addressView];
    
    UILabel *consigneeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 80, 250, 20)];
    consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@   %@",self.model.consignee,self.model.mobile];
    consigneeLabel.textAlignment = 0;
    consigneeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    consigneeLabel.textColor = [UIColor blackColor];
    [headView addSubview:consigneeLabel];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    NSString *labelText = [NSString stringWithFormat:@"%@%@%@%@噢噢噢噢噢噢噢噢哦哦哦噢噢噢噢",_model.province,_model.city,_model.area,_model.address];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:CGFloatMakeY(4)];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    addressLabel.attributedText = attributedString;
    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(12)]};
    CGSize titleSize = [addressLabel.text boundingRectWithSize:CGSizeMake(CGFloatMakeX(394), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
    addressLabel.frame = CGRectMake(CGFloatMakeX(10),CGFloatMakeY(103), titleSize.width, CGFloatMakeY(titleSize.height));
    headView.frame = CGRectMake1(0, 0, 414, 113+CGFloatMakeY(titleSize.height));
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [headView addSubview:addressLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height-CGFloatMakeY(0.5),kWidth,CGFloatMakeY(0.5))];
    lineView1.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [headView addSubview:lineView1];
    
    UIView *commodityView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height+CGFloatMakeY(10), kWidth,CGFloatMakeY(100*_model.goodArr.count))];
    commodityView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:commodityView];
    
    for (int i = 0; i<_model.goodArr.count; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 100*i, 414, 0.5)];
        lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [commodityView addSubview:lineView];
        
        CommodView *commodView = [[CommodView alloc]initWithFrame:CGRectMake1(0, 100*i, 414, 100)];
        CommodModel *commodmodel = _model.goodArr[i];
        commodView.nameLabel.text = commodmodel.title;
        commodView.moneylabel.text = [@"¥" stringByAppendingString:commodmodel.marketprice];
        commodView.numberlabel.text = [NSString stringWithFormat:@"共%@件",commodmodel.total];
        commodView.button.tag = i;
        [commodView.goodDetailBtn addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
        commodView.goodDetailBtn.tag = [commodmodel.aid integerValue];
        [commodView.button addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:commodmodel.thumb] placeholderImage:[UIImage imageNamed:@"lbtP"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake(0, commodityView.frame.origin.y+commodityView.frame.size.height, kWidth, CGFloatMakeY(250))];
    moneyView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:moneyView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [moneyView addSubview:lineView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 0, 404, 40)];
    label1.textAlignment = 0;
    label1.text = @"结算";
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 39.5, 414, 0.5)];
    line1.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [moneyView addSubview:line1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 40, 404, 40)];
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
    line2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [moneyView addSubview:line2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 80, 404, 40)];
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
    line3.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [moneyView addSubview:line3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 120, 404, 40)];
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
    line4.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [moneyView addSubview:line4];
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake1(0, 160, 404, 40)];
    label5.textColor = [UIColor blackColor];
    float mf = _model.goodsprice.floatValue+_model.dispatchprice.floatValue+0;
    NSString *allprice = [NSString stringWithFormat:@"应付总额：¥%.2f",mf];
    NSRange rang1 = NSMakeRange(5, allprice.length -5);
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:allprice];
    [aStr addAttribute:NSForegroundColorAttributeName value:btncolor range:rang1];
    label5.attributedText = aStr;
    label5.textAlignment = 2;
    label5.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [moneyView addSubview:label5];

    scrollView.contentSize = CGSizeMake1(414, 400+_model.goodArr.count*100);
    scrollView.showsVerticalScrollIndicator = NO;
    
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-CGFloatMakeY(62)-64, kWidth,CGFloatMakeY(62))];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake1(233, 20, 80, 30);
    [button1 setTitle:button1Str forState:UIControlStateNormal];
    [button1 setTitleColor:textcolor forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    button1.layer.borderWidth = 0.5;
    button1.layer.borderColor = textcolor.CGColor;
    [button1.layer setCornerRadius:5];
    [btnView addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake1(323, 20, 80, 30);
    [button2 setTitle:button2Str forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [button2.layer setCornerRadius:5];
    button2.backgroundColor = [UIColor whiteColor];
    button2.layer.borderWidth = 0.5;
    button2.layer.borderColor = [UIColor redColor].CGColor;
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
            //scrollView.frame = CGRectMake1(0, 0, 414, 600);
            break;
        case 1:
            statuStr = @"待发货";
            button1Str = @"0";
            button2Str = @"提醒发货";
            [button2 addTarget:self action:@selector(remindAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.hidden = NO;
         //   scrollView.frame = CGRectMake1(0, 0, 414, 600);
            break;
        case 2:
            statuStr = @"待收货";
            button1Str = @"0";
            button2Str = @"确认收货";
            [button2 addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.hidden = NO;
         //   scrollView.frame = CGRectMake1(0, 0, 414, 600);
            break;
        case 3:
            statuStr = @"已完成";
            button1Str = @"0";
            button2Str = @"评价";
            //[button2 addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.hidden = YES;
        //    scrollView.frame = CGRectMake1(0, 0, 414, 672);
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
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定删除订单？"];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                  range:NSMakeRange(0, 7)];
    [alertCon setValue:hogan forKey:@"attributedMessage"];
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
    AFHTTPSessionManager *manager = [self sharedManager];;
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    //发送请求
    [manager POST:kCancel parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"订单已经删除"];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:CGFloatMakeY(14)]
                      range:NSMakeRange(0, 6)];
        [alertCon setValue:hogan forKey:@"attributedMessage"];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3  target:self selector:@selector(hide) userInfo:nil repeats:NO];
        [self presentViewController:alertCon animated:YES completion:nil];
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
    AFHTTPSessionManager *manager = [self sharedManager];;
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    //发送请求
    [manager POST:kRemind parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
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

-(void)hide
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
    timer = nil;
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
    AFHTTPSessionManager *manager = [self sharedManager];;
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    //发送请求
    [manager POST:kUpdata parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.loadingHud hideAnimated:YES];
    self.loadingHud = nil;
    self.navigationController.navigationBarHidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    self.navigationController.navigationBar.translucent = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
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
