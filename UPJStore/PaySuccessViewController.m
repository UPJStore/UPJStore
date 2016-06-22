//
//  PaySuccessViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/13.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "UIViewController+CG.h"
#import "OrderModel.h"
#import "AFNetWorking.h"
#import "OrderViewController.h"

@interface PaySuccessViewController ()
{
    OrderModel *model;
}
@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //例行navigationcontroller设置
    self.navigationItem.title = @"支付成功";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self postOrderData];
    
}
-(void)initView{
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    //   UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *bordercolor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui_@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = backcolor;
    
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 115)];
    redView.backgroundColor = btncolor;
    [self.view addSubview:redView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(60, 35, 80, 20)];
    label1.text = @"买家已付款";
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [redView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake1(60, 70, 120, 20)];
    label2.text = @"你的包裹正整装待发";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [redView addSubview:label2];
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paysuccesslogo@3x.png"]];
    logoView.frame = CGRectMake1(250, 10, 90, 90) ;
    [redView addSubview:logoView];
    
    UIView *successView = [[UIView alloc]initWithFrame:CGRectMake1(0, 115, 414, 170)];
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake1(15, 10, 384, 20)];
    messageLabel.text = [NSString stringWithFormat:@"收货人：%@  %@",model.consignee,model.mobile];
    messageLabel.textColor = bordercolor;
    messageLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [successView addSubview:messageLabel];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake1(15, 40, 384, 20)];
    addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",model.address];
    addressLabel.textColor = bordercolor;
    addressLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [successView addSubview:addressLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 70, 414, 1)];
    lineView1.backgroundColor = fontcolor;
    [successView addSubview:lineView1];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake1(15, 90, 384, 20)];
    priceLabel.text = [NSString stringWithFormat:@"总价：%@元",model.goodsprice];
    priceLabel.textColor = btncolor;
    priceLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    //NSRange rang1 = NSMakeRange(3, allprice.length -3);
    [successView addSubview:priceLabel];
    
    UIButton *cheakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cheakButton.frame = CGRectMake1(40, 120, 80, 30);
    [cheakButton.layer setCornerRadius:5];
    [cheakButton.layer setBorderWidth:0.5];
    [cheakButton.layer setBorderColor:fontcolor.CGColor];
    [cheakButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [cheakButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cheakButton.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [cheakButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [successView addSubview:cheakButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake1(300, 120, 80, 30);
    [backButton.layer setCornerRadius:5];
    [backButton.layer setBorderWidth:0.5];
    [backButton.layer setBorderColor:fontcolor.CGColor];
    [backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [successView addSubview:backButton];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 170, 414, 1)];
    lineView2.backgroundColor = fontcolor;
    [successView addSubview:lineView2];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake1(0, 305, 414, 80)];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake1(15,10, 384, 15)];
    label3.text = @"安全提醒";
    label3.textColor = bordercolor;
    label3.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [textView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake1(15, 25, 384, 40)];
    label4.textColor = bordercolor;
    NSString *str = @"付款成功后，友品集不会以付款异常、卡单、系统为由联系你。请勿泄露银行卡号、手机验证码，否则会造成欠款损失。谨防电话诈骗！";
    NSRange rang2 = NSMakeRange(28, str.length-28);
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:str];
    [aStr addAttribute:NSForegroundColorAttributeName value:btncolor range:rang2];
    label4.attributedText = aStr;
    label4.numberOfLines = 0;
    label4.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [textView addSubview:label4];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake1(0, 395, 414, 341)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
}

-(void)postOrderData
{
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"id":_orderId};
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

    //发送请求
    [manager POST:kDetail parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        model = [[OrderModel alloc]init];
        NSDictionary *dic = responseObject;
        [model setValuesForKeysWithDictionary:dic];
        
        [self initView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
    
}

-(void)tapAction:(UIButton*)btn
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)backAction:(UIButton*)btn
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)pop
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
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