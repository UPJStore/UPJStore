//
//  LoginBindViewController.m
//  UPJStore
//
//  Created by upj on 16/5/6.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "LoginBindViewController.h"
#import "LoginView.h"
#import "UIViewController+CG.h"
#import "TextFieldView.h"
#import "AppDelegate.h"
#import "AFNetWorking.h"
#import "UIColor+HexRGB.h"
#import "PhoneRegisteredViewController.h"

#define widthSize 414.0/320

#define hightSize 736.0/568
@interface LoginBindViewController ()<UITextFieldDelegate>

{
    TextFieldView *name;
    TextFieldView *password;
    UIButton * loginBtn;
    UILabel * label1;
    UILabel * label2;
    UIButton * forgetBtn;
    NSDictionary *jsonDic;
    UIAlertController *alertCon;
    NSString *errcode;
    MemberModel *model;
    
    NSString * num;
}

@end

@implementation LoginBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"绑定登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake1(30,20, 414-60, 30)];
    label1.text = @"关联已有友品集账号";
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
    label1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label1];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake1(30,200, 414-60, 50)];
    label2.text = @"关联后，您的微信帐号和友品集账号都可以登录";
    label2.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    name = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 50, 414, 50) String:@"用户名/手机号" picture:@"phoneIcon" number:414];
    [self.view addSubview:name];
    
    password = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 110, 414, 50) String:@"密码" picture:@"code" number:414];
    [password.textfield setSecureTextEntry:YES];
    [self.view addSubview:password];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake1(20,270,414-40,50);
    [loginBtn setTitle:@"绑定登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:CGFloatMakeY(18)];
    loginBtn.backgroundColor = btncolor;
    loginBtn.tag = 0;
    [loginBtn.layer setCornerRadius:5.0];
    [loginBtn addTarget:self action:@selector(loginBind:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake1(334, 330, 60, 20);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [forgetBtn setTitleColor:[UIColor colorFromHexRGB:@"cc2245"] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    
    // Do any additional setup after loading the view.
}

-(void)loginBind:(UIButton *)sender{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *dic = @{@"ios_wechat_openid":appdelegate.openid,@"uname":name.textfield.text,@"pwd":password.textfield.text,@"appkey":APPkey,@"unionid":appdelegate.unionid};
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //传入的参数
    
    //发送请求
    [manager POST:kLogin parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        errcode = [NSString stringWithFormat:@"%@",number];
        if ([errcode isEqualToString:@"0"]){
            jsonDic = [responseObject valueForKey:@"data"];
            model = [MemberModel new];
            [model setValuesForKeysWithDictionary:jsonDic];
            [appdelegate.delegate loginFinishWithmodel:model];
            self.navigationController.navigationBarHidden = YES;
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
            num = @"back";
        }else{
            NSString *str1 = [responseObject valueForKey:@"errmsg"];
            alertCon = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertCon addAction:okAction];
            [self.navigationController presentViewController:alertCon animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [name resignFirstResponder];
    [password resignFirstResponder];
}

-(void)forgetAction
{
    PhoneRegisteredViewController *FVC = [PhoneRegisteredViewController new];
    FVC.number = 2;
    [self.navigationController pushViewController:FVC animated:YES];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
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
