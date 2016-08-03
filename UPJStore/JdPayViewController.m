//
//  JdPayViewController.m
//  UPJStore
//
//  Created by upj on 16/8/1.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "JdPayViewController.h"
#import "UIViewController+CG.h"

@interface JdPayViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation JdPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"京东支付";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,414, 721)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]];
    DLog(@"%@",request.URL);
    webView.delegate = self;
    [self.view addSubview: webView];
    [webView loadRequest:request];

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"%@",[request.URL absoluteString]);
    
    if ([[request.URL absoluteString] isEqualToString:@"http://m.upinkji.com/wap/pay/jd.html?status=1"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate paysuccess];
        return NO;
    }else if([[request.URL absoluteString] isEqualToString:@"http://m.upinkji.com/wap/pay/jd.html?status=2"])
    {
        [self pop];
        return NO;
    }else
    {
        return YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isShowTab =YES;
    [self hideTabBarWithTabState:self.isShowTab];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate payfail];
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
