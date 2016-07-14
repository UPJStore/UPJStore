//
//  AgentViewController.m
//  UPJStore
//
//  Created by upj on 16/7/12.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AgentViewController.h"
#import "UIViewController+CG.h"

@interface AgentViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}

@end

@implementation AgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden =YES;
    self.navigationItem.title = @"合作商管理平台";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f",time];
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@",[self returnMid],timeString];
    NSString *str2 = [str1 stringByAppendingString:@"GVqI!%@pCrKk#fvKLXat24Ip"];
    
    NSString *str = [self md5:str2];
     NSString *urlstr = [NSString stringWithFormat:@"http://m.upinkji.com/wap/agent/login.html?m=%@&time=%@&str=%@",[self returnMid],timeString,str];
 //  NSString *urlstr = @"http://www.baidu.com";
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,414, 721)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    webView.delegate = self;
    [self.view addSubview: webView];
    [webView loadRequest:request];
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
