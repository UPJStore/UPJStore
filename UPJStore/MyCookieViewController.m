//
//  MyCookieViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/8.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyCookieViewController.h"
#import "ExchangeView.h"
#import "AppDelegate.h"
#import "HowToDoViewController.h"

#define widthSize 414.0/320
#define hightSize 736.0/568

@interface MyCookieViewController ()
{
    UIAlertController *alertCon;
}
@end

@implementation MyCookieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    //  UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *bordercolor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    
    self.navigationItem.title = @"我的饼干";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = backcolor;
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 414, 158*k6PHeight*app.autoSizeScaleY)];
    redView.backgroundColor = btncolor;
    [self.view addSubview:redView];
    
    UIButton *questionbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    questionbutton.frame = CGRectMake1(8*k6PWidth, 7*k6PHeight,80*k6PWidth, 30*k6PHeight);
    [questionbutton setImage:[UIImage imageNamed:@"cookieicon_01"] forState:UIControlStateNormal];
    questionbutton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40*k6PWidth);
    questionbutton.titleLabel.font = [UIFont systemFontOfSize:10*k6PHeight*app.autoSizeScaleY];
    [questionbutton setTitle:@"怎样赚取" forState:UIControlStateNormal];
    [questionbutton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:questionbutton];
    
    UIButton *remindbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    remindbutton.frame = CGRectMake1(414-91*k6PWidth, 7*k6PHeight, 83*k6PWidth, 30*k6PHeight);
    [remindbutton setImage:[UIImage imageNamed:@"cookieicon_02"] forState:UIControlStateNormal];
    
    UIImageView *cookieImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cookieicon_03"]];
    cookieImageView.frame = CGRectMake1(414/2-52*k6PWidth,80*k6PHeight, 52*k6PWidth, 67*k6PHeight);
    [self.view addSubview:cookieImageView];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake1(179*k6PWidth, 64+42*k6PHeight, 35, 58)];
    numberLabel.text = @"0";
    numberLabel.textAlignment = 1;
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.font = [UIFont boldSystemFontOfSize:48];
    [self.view addSubview:numberLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 218*k6PHeight, 414, 0.5)];
    lineView.backgroundColor = fontcolor;
    [self.view addSubview:lineView];
    
    UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake1(8*k6PWidth, 225*k6PHeight, 60*k6PWidth, 10*k6PHeight)];
    label3.text = @"兑换优惠券";
    label3.textAlignment = 1;
    label3.textColor = bordercolor;
    label3.font = [UIFont systemFontOfSize:10*k6PHeight*app.autoSizeScaleY];
    [self.view addSubview:label3];
    
    ExchangeView* exchangeView1 = [[ExchangeView alloc]initWithFrame:CGRectMake1(8*k6PWidth, 245*k6PHeight, 414-16*k6PWidth, 35*k6PHeight)picture:@"shi@2x.png" string1:@"满199减10" string2:@"100饼干"];
    [exchangeView1.layer setBorderWidth:1.0];
    [exchangeView1.layer setCornerRadius:10.0];
    [exchangeView1.layer setBorderColor:fontcolor.CGColor];
    [self.view addSubview:exchangeView1];
    
    ExchangeView* exchangeView2 = [[ExchangeView alloc]initWithFrame:CGRectMake1(8*k6PWidth, 285*k6PHeight, 414-16*k6PWidth, 35*k6PHeight)picture:@"ershi@2x.png" string1:@"满299减10" string2:@"200饼干"];
    [exchangeView2.layer setBorderWidth:1.0];
    [exchangeView2.layer setCornerRadius:10.0];
    [exchangeView2.layer setBorderColor:fontcolor.CGColor];
    [self.view addSubview:exchangeView2];
    
    ExchangeView* exchangeView3 = [[ExchangeView alloc]initWithFrame:CGRectMake1(8*k6PWidth,325*k6PHeight, 414-16*k6PWidth, 35*k6PHeight)picture:@"wushi@2x.png" string1:@"满499减10" string2:@"400饼干"];
    [exchangeView3.layer setBorderWidth:1.0];
    [exchangeView3.layer setCornerRadius:10.0];
    [exchangeView3.layer setBorderColor:fontcolor.CGColor];
    [self.view addSubview:exchangeView3];
    
    for (int i = 0 ; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = btncolor;
        [button setTitle:@"兑换" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = i;
        [button.layer setCornerRadius:5.0];
        button.titleLabel.textAlignment = 1;
        button.titleLabel.font = [UIFont systemFontOfSize:9*k6PHeight*app.autoSizeScaleY];
        button.frame = CGRectMake1(414-65*k6PWidth, (250+(40*i))*k6PHeight, 50*k6PWidth, 25*k6PHeight);
        [button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }

}

-(void)changeAction:(UIButton*)btn
{
    alertCon = [UIAlertController alertControllerWithTitle:nil message:@"积分不足，兑换失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertCon addAction:okAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}

-(void)tapAction
{
    HowToDoViewController *htdc = [HowToDoViewController new];
    [self.navigationController pushViewController:htdc animated:YES];
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
    self.navigationController.navigationBar.translucent = YES;
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
