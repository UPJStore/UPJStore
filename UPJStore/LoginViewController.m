//
//  LoginViewController.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "AppDelegate.h"
#import "PhoneRegisteredViewController.h"
#import "MemberModel.h"
#import "AFNetworking.h"
#import "UIViewController+CG.h"
#import "MBProgressHUD.h"
#import "BindViewController.h"


#define widthSize 414.0/320
#define hightSize 736.0/568

@interface LoginViewController ()<TapAciton>
{
    NSDictionary *jsonDic;
    MemberModel *model;
    UIAlertController *alertCon;
    NSString *errcode;
    NSTimer * timer;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    // 添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(display)
                                                 name:@"Note1"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pop)
                                                 name:@"Note2"
                                               object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop2)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    self.view.backgroundColor = backcolor;
    LoginView *loginView = [[LoginView alloc]initWithFrame:CGRectMake1(0, 0, 414, 736)];
    loginView.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.view addSubview:loginView];
    // Do any additional setup after loading the view.
}

-(void)tapAction:(UIButton *)button dic:(NSDictionary *)dic
{
    switch (button.tag) {
        case 0:
        {
            [self setMBHUD];
            [self postDataWith:dic];
        }
            break;
        case 1:
        {
            PhoneRegisteredViewController *rev = [PhoneRegisteredViewController new];
            rev.number = 1;
            [self.navigationController pushViewController:rev animated:YES];
        }
            break;
        case 2:
        {
            PhoneRegisteredViewController *rev = [PhoneRegisteredViewController new];
            rev.number = 2;
            [self.navigationController pushViewController:rev animated:YES];
        }
            break;
        case 8:
            [self sendAuthRequest];
            break;
        default:
            break;
    }
    
}
-(void)sendAuthRequest
{
    if([WXApi isWXAppInstalled]){
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ]init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }else{
        // 隐藏
        [self setupAlertController];
    }
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)postDataWith:(NSDictionary*)dic
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
    //    NSDictionary *parameters = @{@"uname":@"18825040608",@"pwd":@"12345678"};
    
    //发送请求
    [manager POST:kLogin parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        errcode = [NSString stringWithFormat:@"%@",number];
        if ([errcode isEqualToString:@"0"])
        {
            jsonDic = [responseObject valueForKey:@"data"];
            model = [MemberModel new];
            [model setValuesForKeysWithDictionary:jsonDic];
            [self loginFinish];
        }
        else
        {
            [_loadingHud hideAnimated:YES];
            _loadingHud =nil;
            NSString *str1 = [responseObject valueForKey:@"errmsg"];
            alertCon = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
            timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            [self presentViewController:alertCon animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)postaddress
{
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
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
    
    //发送请求
    
    [manager POST:kShow parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
        [self setAddresswithAddress:jsonArr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)postcollect
{
    
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
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
    
    //发送请求
    [manager POST:kCollectList parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
        [self setCollectwithCollect:jsonArr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)postattention
{
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    
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
    
    //发送请求
    [manager POST:kAllBrand parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        NSString *errcode2 = [NSString stringWithFormat:@"%@",number];
        if ([errcode2 isEqualToString:@"10235"]) {
            NSArray *jsonArr = [NSArray new];
            [self setAttentionwithAttention:jsonArr];
        }else{
            NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
            [self setAttentionwithAttention:jsonArr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)loginFinish
{
    if (_isFromDetail == YES)
    {
        [self setMidwithMid:model.mid];
        if (model.nickname.length != 0) {
            [self setNamewithNickName:model.nickname];
        }else
        {
            [self setNamewithNickName:@"0"];
        }
        if (model.realname.length != 0) {
            [self setNamewithRealName:model.realname];
        }else
        {
            [self setNamewithRealName:@"0"];
        }
        if (model.idcard.length != 0) {
            [self setIdCardwithIdCard:model.idcard];
        }else
        {
            [self setIdCardwithIdCard:@"0"];
        }
        if (model.mobile.length != 0) {
            [self setPhoneNumberwithPhoneNumber:model.mobile];
        }else
        {
            [self setPhoneNumberwithPhoneNumber:@"0"];
        }
        if(model.avatar.length != 0)
        {
            [self setImagewithImage:model.avatar];
            NSURL *url = [NSURL URLWithString:model.avatar];
            NSData *data = [[NSData alloc]initWithContentsOfURL:url];
            [self setImagedatawithImagedata:data];
        }else
        {
            [self setImagewithImage:@"0"];
        }
        [self setIsLoginwithIsLogin:YES];
        [self postaddress];
        [self postcollect];
        [self postattention];
    }
    [self.delegate loginFinishWithmodel:model];
    [self pop];
}

#pragma mark -- 微信
- (void)display {
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_loadingHud hideAnimated:YES];
    _loadingHud =nil;
    BindViewController *bindVC = [[BindViewController alloc]init];
    bindVC.nicknameStr = appdelegate.nickname;
    bindVC.headimgurl = appdelegate.headimgurl;
    [self.navigationController pushViewController:bindVC animated:YES];
    
    //    [_LoginBtn setHidden:YES];
}

-(void)pop
{
    [_loadingHud hideAnimated:YES];
    _loadingHud =nil;
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hide) userInfo:nil repeats:NO];
    [self presentViewController:alert1 animated:YES completion:nil];
}

-(void)hide
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [timer invalidate];
    timer = nil;
}

-(void)pop2
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismiss
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
    timer = nil;
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

-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the custom view mode to show any view.
    /*
     _loadingHud.mode = MBProgressHUDModeCustomView;
     UIImage *gif = [UIImage sd_animatedGIFNamed:@"youpinji"];
     
     UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
     _loadingHud.customView = gifView;
     */
    _loadingHud.bezelView.backgroundColor = [UIColor lightGrayColor];
    _loadingHud.animationType = MBProgressHUDAnimationFade;
    _loadingHud.backgroundColor = [UIColor clearColor];
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
