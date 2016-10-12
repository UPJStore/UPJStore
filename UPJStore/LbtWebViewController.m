//
//  LbtWebViewController.m
//  UPJStore
//
//  Created by upj on 16/9/9.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "LbtWebViewController.h"
#import "UIViewController+CG.h"
#import "GoodSDetailViewController.h"

@interface LbtWebViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}

@end

@implementation LbtWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = _titlestr;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake1(0, 0,414, 721)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_urlstr]];
    webView.delegate = self;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;

    [self.view addSubview: webView];
    [webView loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url1 = [NSString stringWithFormat:@"%@",request.URL];
    if (url1.length > 43) {
        NSString *url2 = [url1 substringWithRange:NSMakeRange(0, 44)];
        if ([url2 isEqualToString:@"http://m.upinkji.com/wap/product/detail.html"]) {
            NSString *url3 = [url1 substringWithRange:NSMakeRange(48, url1.length-48)];
            [self pushWithgoodsid:url3];
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return YES;
    }
}

-(void)pushWithgoodsid:(NSString *)goodsid
{
    GoodSDetailViewController *GDVC = [GoodSDetailViewController new];
    NSDictionary * dic = @{@"appkey":APPkey,@"id":goodsid};
    GDVC.goodsDic = dic;
    [self.navigationController pushViewController:GDVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isShowTab =YES;
    [self hideTabBarWithTabState:self.isShowTab];
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
