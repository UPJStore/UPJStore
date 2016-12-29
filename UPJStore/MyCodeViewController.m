//
//  MyCodeViewController.m
//  UPJStore
//
//  Created by upj on 16/11/5.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyCodeViewController.h"
#import "UIViewController+CG.h"

@interface MyCodeViewController ()
@property(nonatomic,strong)NSString *imgpath;

@end

@implementation MyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    [self setMBHUD];
    NSDictionary *dic = [NSDictionary new];
    if (_isShare) {
        dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"mid":[self returnMid],@"share":@"0"};
    }else{
        dic = @{@"appkey":APPkey,@"member_id":[self returnMid],@"mid":[self returnMid],@"share":@"1"};
    }
    [self postdataWithDic:dic];
}

-(void)postdataWithDic:(NSDictionary *)dic
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",nil];
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KGetPromote parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        _imgpath = dic[@"imgpath"];
        [self initWithImg];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)initWithImg
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.upinkji.com/static/images/Qrcode/%@",_imgpath]]];
    [self.view addSubview:imageView];
    [self.loadingHud hideAnimated:YES];
    self.loadingHud =nil;
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.isShowTab =YES;
    [self hideTabBarWithTabState:self.isShowTab];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
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
