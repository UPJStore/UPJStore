//
//  HowToDoViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/30.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "HowToDoViewController.h"
#import "UIView+cg.h"
#import "TextView.h"

@interface HowToDoViewController ()

@end

@implementation HowToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    
    self.navigationItem.title = @"饼干说明";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = backcolor;
    
    TextView *text1 = [[TextView alloc]initWithFrame:CGRectMake1(0, 10, 414, 20) isquestion:YES str:@"什么是饼干？"];
    [self.view addSubview:text1];
    
    TextView *text2 = [[TextView alloc]initWithFrame:CGRectMake1(0, 30, 414, 20) isquestion:NO str:@"饼干为有品集全球购用户专属积分。"];
    [self.view addSubview:text2];
    
    TextView *text3 = [[TextView alloc]initWithFrame:CGRectMake1(0, 60, 414, 20) isquestion:YES str:@"饼干有什么用？"];
    [self.view addSubview:text3];
    
    TextView *text4 = [[TextView alloc]initWithFrame:CGRectMake1(0, 80, 414, 20) isquestion:NO str:@"饼干可用于兑换优惠券。"];
    [self.view addSubview:text4];
    
    TextView *text5 = [[TextView alloc]initWithFrame:CGRectMake1(0, 110, 414, 20) isquestion:YES str:@"怎么获取饼干？"];
    [self.view addSubview:text5];
    
    TextView *text6 = [[TextView alloc]initWithFrame:CGRectMake1(0, 130, 414, 40) isquestion:NO str:@"目前两种途径:1.购买商品送饼干，2.分享商品送饼干。"];
    [self.view addSubview:text6];
    
    TextView *text7 = [[TextView alloc]initWithFrame:CGRectMake1(0, 180, 414, 20) isquestion:YES str:@"什么是商品分享赚取？"];
    [self.view addSubview:text7];
    
    TextView *text8 = [[TextView alloc]initWithFrame:CGRectMake1(0, 200, 414, 20) isquestion:NO str:@"分享赚取是鼓励用户分享商品的一个饼干活动。"];
    [self.view addSubview:text8];
    
    TextView *text9 = [[TextView alloc]initWithFrame:CGRectMake1(0, 230, 414, 20) isquestion:YES str:@"怎样参与分享赚取活动？"];
    [self.view addSubview:text9];
    
    TextView *text10 = [[TextView alloc]initWithFrame:CGRectMake1(0, 250, 414, 40) isquestion:NO str:@"将商品的商品详情页面分享出去，如果别人通过你分享的链接购买商品，你将会得到饼干奖励。"];
    [self.view addSubview:text10];
    
    TextView *text11 = [[TextView alloc]initWithFrame:CGRectMake1(0, 300, 414, 20) isquestion:YES str:@"分享赚取的饼干什么时候到账？"];
    [self.view addSubview:text11];
    
    TextView *text12 = [[TextView alloc]initWithFrame:CGRectMake1(0, 320, 414, 40) isquestion:NO str:@"当你的朋友通过你的分享的商品链接购买该活动商品。你将获得饼干奖励，等你的朋友确认收货7个工作日后，饼干将会到账。"];
    [self.view addSubview:text12];
    
    TextView *text13 = [[TextView alloc]initWithFrame:CGRectMake1(0, 370, 414, 20) isquestion:YES str:@"怎么获取饼干？"];
    [self.view addSubview:text13];
    
    TextView *text14 = [[TextView alloc]initWithFrame:CGRectMake1(0, 390, 414, 40) isquestion:NO str:@"目前两种途径:1.购买商品送饼干，2.分享商品送饼干。"];
    [self.view addSubview:text14];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
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
