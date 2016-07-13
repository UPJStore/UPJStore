//
//  BindViewController.m
//  BindWechatDemo
//
//  Created by upj on 16/4/21.
//  Copyright © 2016年 upj. All rights reserved.
//

#import "BindViewController.h"
#import "UIViewController+CG.h"
#import "AppDelegate.h"
#import "PhoneRegisteredViewController.h"
#import "LoginBindViewController.h"



@interface BindViewController ()

@property (strong, nonatomic) UIImageView *imageView; // 用户头像
@property (nonatomic,strong)UILabel *nickname; // 用户名

@property (nonatomic,strong)UILabel *serverLabel;

@property (nonatomic,strong)UILabel *registerLabel;

@property (nonatomic,strong)UIButton *registerBtn;

@property (nonatomic,strong)UILabel *bindLabel;

@property (nonatomic,strong)UIButton *bindBtn;

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号绑定";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    
    // 初始化头像
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.center = CGPointMake(kWidth/2,CGFloatMakeY(70));
    _imageView.layer.cornerRadius = 50; // 设置为圆形
    _imageView.layer.masksToBounds = YES; // 若不加这句话，加载的图片还是矩形的。
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_headimgurl]]];
    _imageView.image = image;
    [self.view addSubview:_imageView];
    
    // 初始化昵称
    _nickname = [[UILabel alloc]initWithFrame:CGRectMake1(10, 174, k6PWidth-20, 50)];
    _nickname.textAlignment = NSTextAlignmentLeft;
    _nickname.text = [NSString stringWithFormat:@"亲爱的微信用户：%@",_nicknameStr];
    _nickname.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_nickname];
    
    // 初始化Label
    _serverLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 200, k6PWidth-20, 50)];
    _serverLabel.text = @"为了给您更好的服务，请关联一个友品集账号";
    _serverLabel.font = [UIFont systemFontOfSize:15];
    _serverLabel.numberOfLines = 0;
    _serverLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_serverLabel];
    
    _registerLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 270, k6PWidth-20, 30)];
    _registerLabel.text = @"还没有友品集账号?";
    _registerLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    _registerLabel.textColor = [UIColor lightGrayColor];
    _registerLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_registerLabel];
    
    _bindLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 370, k6PWidth-20, 30)];
    _bindLabel.text = @"已有友品集账号?";
    _bindLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    _bindLabel.textColor = [UIColor lightGrayColor];
    _bindLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_bindLabel];
    
    // 注册btn
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.frame = CGRectMake1(10,300, k6PWidth-20, 50);
    [_registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    _registerBtn.backgroundColor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    _registerBtn.layer.cornerRadius = 5;
    [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    // 关联btn
    _bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bindBtn.frame = CGRectMake1(10, 400, k6PWidth-20, 50);
    [_bindBtn setTitle:@"立即关联" forState:UIControlStateNormal];
    [_bindBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _bindBtn.backgroundColor = [UIColor whiteColor];
    _bindBtn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _bindBtn.layer.borderWidth = 1;
    _bindBtn.layer.cornerRadius = 5;
    [_bindBtn addTarget:self action:@selector(loginBindAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindBtn];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark -- 快速注册
-(void)registerAction:(UIButton *)sender{
    PhoneRegisteredViewController *rev = [[PhoneRegisteredViewController alloc]init];
    rev.number = 3;
    [self.navigationController pushViewController:rev animated:YES];
}
#pragma mark -- 绑定登录
-(void)loginBindAction:(UIButton *)sender{
    LoginBindViewController *loginBVC = [[LoginBindViewController alloc]init];
    [self.navigationController pushViewController:loginBVC animated:YES];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
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
