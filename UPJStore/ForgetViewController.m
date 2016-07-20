//
//  ForgetViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ForgetViewController.h"
#import "TextFieldView.h"
#import "UIViewController+CG.h"

#define widthSize 414.0/320
#define hightSize 736.0/568

@interface ForgetViewController ()
{
    TextFieldView *passwordTextFieldView;
    UISwitch *passwordSwitch;
    TextFieldView *passwordTextFieldView2;
    UISwitch *passwordSwitch2;
    UIButton *nextBtn;
    UIAlertController *alertCon;
    NSString *errcode;
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    self.view.backgroundColor = backcolor;
    
    self.navigationItem.title = @"重置密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    
    passwordTextFieldView = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 26, 414, 736) String:@"6-18位的英文或数字的密码" picture:@"code" number:414];
    [passwordTextFieldView passwordHide];
    [self.view addSubview:passwordTextFieldView];
    
    passwordSwitch =[[UISwitch alloc]initWithFrame:CGRectMake1(316, 47, 39, 26)];
    [passwordSwitch addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    passwordSwitch.tag = 1;
    [self.view addSubview:passwordSwitch];
    [passwordTextFieldView addRightView:passwordSwitch];
    
    passwordTextFieldView2 = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 91, 414, 736) String:@"重复密码" picture:@"code" number:414];
    [passwordTextFieldView2 passwordHide];
    [self.view addSubview:passwordTextFieldView2];
    
    passwordSwitch2 =[[UISwitch alloc]initWithFrame:CGRectMake1(316, 112, 39, 26)];
    [passwordSwitch2 addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    passwordSwitch2.tag = 2;
    [self.view addSubview:passwordSwitch2];
    [passwordTextFieldView2 addRightView:passwordSwitch2];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake1(26, 169, 362, 51);
    [nextBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    nextBtn.backgroundColor = btncolor;
    [nextBtn.layer setCornerRadius:5.0];
    [nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

-(void)pop
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
}

-(void)passwordAction:(UISwitch*)passSwitch
{
    if (passSwitch.tag == 1)
    {
        if (passSwitch.isOn != YES)
        {
            [passwordTextFieldView passwordHide];
        }else
        {
            [passwordTextFieldView passwordShow];
        }
    }
    else
    {
        if (passSwitch.isOn != YES)
        {
            [passwordTextFieldView2 passwordHide];
        }else
        {
            [passwordTextFieldView2 passwordShow];
        }
    }
}

-(void)nextAction:(UIButton*)Btn
{
    if ([self checkPassword:passwordTextFieldView.textfield.text])
    {
        if ([self checkPasswordAgain]) {
            //进行注册
            [self setMBHUD];
            NSDictionary *dic = @{@"uname":_phoneNumber,@"pwd":passwordTextFieldView.textfield.text,@"appkey":APPkey};
            [self postDataWith:dic];
        }
        else
        {
            alertCon = [UIAlertController alertControllerWithTitle:nil message:@"两次输入的密码不正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertCon addAction:okAction];
            [self presentViewController:alertCon animated:YES completion:nil];
        }
    }
    else
    {
        alertCon = [UIAlertController alertControllerWithTitle:nil message:@"请输入6-18位的英文或数字的密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:okAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
    
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
    
    //发送请求
    [manager POST:kForget parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        errcode = [NSString stringWithFormat:@"%@",number];
        if (![errcode isEqualToString:@"0"])
        {
            NSString *str1 = [responseObject valueForKey:@"errmsg"];
            alertCon = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertCon addAction:okAction];
            [self presentViewController:alertCon animated:YES completion:nil];
        }else
        {
            alertCon = [UIAlertController alertControllerWithTitle:nil message:@"重置成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pop];
            }];
            [alertCon addAction:okAction];
            [self presentViewController:alertCon animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

- (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^[0-9_a-zA-Z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

-(BOOL)checkPasswordAgain
{
    return [passwordTextFieldView.textfield.text isEqualToString:passwordTextFieldView2.textfield.text];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    self.navigationController.navigationBar.translucent =NO;
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
