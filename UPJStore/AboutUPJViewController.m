//
//  AboutUPJViewController.m
//  UPJStore
//
//  Created by upj on 16/3/11.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AboutUPJViewController.h"
#import "UIViewController+CG.h"
#import "AFNetWorking.h"
#import "WXApi.h"

@interface AboutUPJViewController ()
@property (nonatomic,strong) NSString * urlSTR ;
@end

@implementation AboutUPJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"关于友品集";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    UIImageView * logoView= [[UIImageView alloc]initWithFrame:CGRectMake1(135, 80, 144,150)];
    
    [logoView setImage:[UIImage imageNamed:@"sharelogo"]];
    
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:logoView];
    
    UIImageView *QRcodeView = [[UIImageView alloc]initWithFrame:CGRectMake1(145, 108+100, 124, 108)];
    
    [QRcodeView setImage:[UIImage imageNamed:@"saomaLogo"]];
    
    QRcodeView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:QRcodeView];
    
    UILabel *strLabel = [[UILabel alloc]initWithFrame:CGRectMake1(109, 332, 202, 50)];
    
    NSMutableAttributedString * atStr =[[NSMutableAttributedString alloc] initWithString:@"扫一扫二维码，关注我们\n让你的小伙伴们也拥有友品集吧"];
    strLabel.numberOfLines= 2;
    strLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    strLabel.textAlignment = NSTextAlignmentCenter;
    strLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
   [atStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:70.0/255 alpha:1] range:NSMakeRange(0,6)];
       [atStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:70.0/255 alpha:1] range:NSMakeRange(22,3)];
       strLabel.attributedText =atStr;
    [self.view addSubview:strLabel];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame =  CGRectMake1(136, 400, 140, 50);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"AboutButton"] forState:UIControlStateNormal];    
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [shareBtn setTitle:@"点击分享给好友" forState:UIControlStateNormal];
    
    if([WXApi isWXAppInstalled]){
        [self.view addSubview:shareBtn];
    }
}

-(void)shareAction:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"点击下载友品集APP，开启品质新生活";
    message.description = @"友品集APP隆重上线啦~与我们乘着友谊的巨轮进入跨境购物的伟大航道，想得到物美价廉的海外商品吗？快来寻宝吧！！";
    [message setThumbImage:[UIImage imageNamed:@"lbtP"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _urlSTR;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}


-(void)getData
{
    NSDictionary * dic =@{@"appkey":APPkey,@"mid":[self returnMid]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    
    [manager POST:kShareUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            DLog(@"%@",responseObject);
            
            _urlSTR = responseObject[@"data"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"%@",error);
        
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
