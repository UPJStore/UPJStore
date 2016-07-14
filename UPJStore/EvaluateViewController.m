//
//  EvaluateViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/1.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "EvaluateViewController.h"
#import "UIViewController+CG.h"
#import "CommodModel.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface EvaluateViewController ()<UITextViewDelegate>
{
    UIView *commodityView;
    UILabel *headLabel;
    UITextView *textView1;
    UIView *evaluteView;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    UIButton *btn6;
    UIButton *btn7;
    UIButton *btn8;
    UIButton *btn9;
    UIButton *btn10;
    NSString *star1;
    NSString *star2;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    //  UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    // UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    // UIColor *bordercolor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    UIColor *holdcolor = [UIColor colorWithWhite:0.75 alpha:1];
    
    self.navigationItem.title = @"评价";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = backcolor;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(tapAction:)];
    
    
    
    commodityView = [[UIView alloc]initWithFrame:CGRectMake1(0, 5, 414, 120)];
    commodityView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:commodityView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10, 100, 100)];
    CommodModel *model1 = _model.goodArr[0];
    imageView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model1.thumb]]];
    [imageView.layer setBorderWidth:0.5];
    [commodityView addSubview:imageView];
    
    star1 = [NSString new];
    star1 = @"0";
    star2 = [NSString new];
    star2 = @"0";
    
    textView1 = [[UITextView alloc]initWithFrame:CGRectMake1(120, 10, 284, 100)];
    [textView1.layer setCornerRadius:5.0];
    [textView1.layer setBorderWidth:0.2];
    [textView1.layer setBorderColor:fontcolor.CGColor];
    textView1.delegate = self;
    textView1.textAlignment = 0;
    textView1.backgroundColor = [UIColor whiteColor];
    textView1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [commodityView addSubview:textView1];
    
    headLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 7, 278, 16)];
    headLabel.text = @"请写下对商品的评价~";
    headLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    headLabel.textColor = holdcolor;
    [textView1 addSubview:headLabel];
    
    evaluteView = [[UIView alloc]initWithFrame:CGRectMake1(0, 135, 414, 130)];
    evaluteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:evaluteView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 10, 414, 30)];
    label1.text = @"评分";
    label1.textAlignment = 0;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont boldSystemFontOfSize:CGFloatMakeY(18)];
    [evaluteView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 50, 200, 30)];
    label2.text = @"描述相符";
    label2.textAlignment = 0;
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [evaluteView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake1(10, 90, 200, 30)];
    label3.text = @"发货速度";
    label3.textAlignment = 0;
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [evaluteView addSubview:label3];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake1(290, 55, 20, 20);
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    [btn2 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn2.frame = CGRectMake1(312, 55, 20, 20);
    [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn2];
    
    
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    [btn3 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn3.frame = CGRectMake1(334, 55, 20, 20);
    [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn3];
    
    btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    [btn4 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn4.frame = CGRectMake1(356, 55, 20, 20);
    [btn4 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn4];
    
    btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.tag = 5;
    [btn5 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn5.frame = CGRectMake1(378, 55, 20, 20);
    [btn5 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn5];
    
    btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.tag = 6;
    [btn6 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn6.frame = CGRectMake1(290, 95, 20, 20);
    [btn6 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn6];
    
    btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.tag = 7;
    [btn7 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn7.frame = CGRectMake1(312, 95, 20, 20);
    [btn7 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn7];
    
    btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn8.tag = 8;
    [btn8 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn8.frame = CGRectMake1(334, 95, 20, 20);
    [btn8 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn8];
    
    btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn9.tag = 9;
    [btn9 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn9.frame = CGRectMake1(356, 95, 20, 20);
    [btn9 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn9];
    
    btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn10.tag = 10;
    [btn10 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
    btn10.frame = CGRectMake1(378, 95, 20, 20);
    [btn10 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluteView addSubview:btn10];
    
}

-(void)btnAction:(UIButton*)btn
{
    switch (btn.tag) {
        case 1:
        {
            [btn1 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star1 = @"1";
        }
            break;
        case 2:
        {
            [btn1 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star1 = @"2";
        }
            break;
        case 3:
        {
            [btn1 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star1 = @"3";
        }
            break;
        case 4:
        {
            [btn1 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star1 = @"4";
        }
            break;
        case 5:
        {
            [btn1 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            star1 = @"5";
        }
            break;
        case 6:
        {
            [btn6 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn7 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn8 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn9 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn10 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star2 = @"1";
        }
            break;
        case 7:
        {
            [btn6 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn7 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn8 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn9 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn10 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star2 = @"2";
        }
            break;
        case 8:
        {
            [btn6 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn7 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn8 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn9 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            [btn10 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star2 = @"3";
        }
            break;
        case 9:
        {
            [btn6 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn7 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn8 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn9 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn10 setBackgroundImage:[UIImage imageNamed:@"blackStarIcon"] forState:UIControlStateNormal];
            star2 = @"4";
        }
            break;
        case 10:
        {
            [btn6 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn7 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn8 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn9 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            [btn10 setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
            star2 = @"5";
        }
            break;
        default:
            break;
    }
}

-(void)tapAction:(UIButton*)btn
{
    [self setMBHUD];
    CommodModel *model1 = _model.goodArr[self.Sequence];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"orderid":self.model.orderid,@"content":textView1.text,@"goodsid":model1.aid,@"star":star1,@"ostar":star2};
    [self postDataWith:dic];
}

-(void)postDataWith:(NSDictionary*)dic
{
    NSDictionary * Ndic = [self md5DicWith:dic];
    AFHTTPSessionManager *manager = [self sharedManager];;
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    //如果报接受类型不一致请替换一致text/html或别的
    //传入的参数
    //发送请求
    [manager POST:kEvaluate parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
        UIAlertController *alertCon2 = [UIAlertController alertControllerWithTitle:nil message:@"反馈成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertCon2 addAction:okAction];
        [self presentViewController:alertCon2 animated:YES completion:nil];
        [self pop];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)textViewDidChange:(UITextView *)textView
{
    headLabel.hidden = YES;
    if (textView.text.length == 0) {
        headLabel.hidden = NO;
    }
}

#pragma mark -- 加载动画
-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
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
