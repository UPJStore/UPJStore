//
//  RegisteredViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/2.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "PhoneRegisteredViewController.h"
#import "TextFieldView.h"
#import "NameRegisteredViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIViewController+CG.h"
#import "ForgetViewController.h"

#define widthSize 414.0/320
#define hightSize 736.0/568


@interface PhoneRegisteredViewController ()<UITextFieldDelegate>
{
    TextFieldView *registerview;
    UIButton *nextBtn;
    UILabel *label;
    UIAlertController *alertCon;
    UIAlertController *alertCon2;
    UIAlertController *alertCon3;
    NSTimer* timer;
    NSTimer* numberTimer;
    NSInteger timeNumber;
    NSString *timeString;
    TextFieldView *validationTextField;
    UIButton *validationBtn;
    BOOL isregistered;
    NSString *vcode;
}

@end

@implementation PhoneRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    self.view.backgroundColor = backcolor;
    
    self.navigationItem.title = @"手机验证";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    registerview = [[TextFieldView alloc]initWithFrame:CGRectMake1(0,10, 414, 736) String:@"手机号" picture:@"phoneIcon甲硝"number:414];
    registerview.textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:registerview];
    
    validationTextField = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 70, 414/3*2,736)String:@"验证码" picture:nil number:414/3*2];
    [self.view addSubview:validationTextField];
    
    validationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    validationBtn.frame = CGRectMake1(414/3*2,80, 414/3-20, 50);
    [validationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    validationBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    validationBtn.backgroundColor = btncolor;
    [validationBtn.layer setCornerRadius:5.0];
    [validationBtn addTarget:self action:@selector(getAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:validationBtn];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake1(20, 150, 414-40, 50);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    nextBtn.backgroundColor = btncolor;
    [nextBtn.layer setCornerRadius:5.0];
    [nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 210, 414, 12)];
    label.text = @"我们将发送验证码到你填写的手机上";
    label.textAlignment =1;
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    label.textColor = fontcolor;
    [self.view addSubview:label];
    
    alertCon = [UIAlertController alertControllerWithTitle:nil message:@"已发送验证码" preferredStyle:UIAlertControllerStyleAlert];
    
    
    alertCon2 = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的11位号码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertCon2 addAction:okAction];
    
    timeString = @"重新发送";
}

-(void)getAction:(UIButton*)button
{
    if ([self validatePhone:registerview.textfield.text])
    {
        
        NSString *string = button.titleLabel.text;
        if ([string isEqualToString:@"获取验证码"]||[string isEqualToString:@"重新发送"])
        {
            NSDictionary *dic = @{@"appkey":APPkey,@"phone":registerview.textfield.text};
            self.phoneNumber = registerview.textfield.text;
            [self postDataWith:dic];
            timeNumber = 60;
            timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hide) userInfo:nil repeats:NO];
            [self presentViewController:alertCon animated:YES completion:nil];
            validationBtn.userInteractionEnabled=NO;
            numberTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(add) userInfo:nil repeats:YES];
        }
    }
    else
    {
        [self presentViewController:alertCon2 animated:YES completion:nil];
    }
}

-(BOOL)validatePhone:(NSString*)phone
{
    NSString*phoneRegex=@"1[3|5|7|8|][0-9]{9}";
    
    NSPredicate*phoneTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return[phoneTest evaluateWithObject:phone];
}

-(void)hide
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
}

-(void)add
{
    if (timeNumber!=0) {
        NSString *string =[NSString stringWithFormat:@"(%ldS)",(long)timeNumber];
        NSString *titileString = [timeString stringByAppendingString:string];
        [validationBtn setTitle:titileString forState:UIControlStateNormal];
        timeNumber--;
    }
    else
    {
        [validationBtn setTitle:timeString forState:UIControlStateNormal];
        validationBtn.userInteractionEnabled=YES;
        [numberTimer invalidate];
    }
}

-(void)postDataWith:(NSDictionary*)dic
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    [manager POST:kVcode parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        vcode = responseObject[@"vcode"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkPhone
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
#pragma dic MD5
    NSDictionary *dic = @{@"appkey":APPkey,@"phone":registerview.textfield.text};
    NSDictionary * Ndic = [self md5DicWith:dic];
    [manager POST:kCheckPhone parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSString *errcode = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if ([errcode isEqualToString:@"1"])
        {
            alertCon = [UIAlertController alertControllerWithTitle:nil message:@"此手机已经被注册" preferredStyle:UIAlertControllerStyleAlert];
            timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hide) userInfo:nil repeats:NO];
            [self presentViewController:alertCon animated:YES completion:nil];
            isregistered = NO;
        }
        if ([errcode isEqualToString:@"0"]) {
            isregistered = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        isregistered = NO;
    }];
    return isregistered;
}

-(void)nextAction:(UIButton*)button
{
    if ([registerview.textfield.text isEqualToString:self.phoneNumber]&&[validationTextField.textfield.text isEqualToString:vcode]) {
        if (self.number == 2) {
            ForgetViewController *FGVC = [ForgetViewController new];
            FGVC.phoneNumber = registerview.textfield.text;
            [self.navigationController pushViewController:FGVC animated:YES];
        }
        else
        {
            if ([self checkPhone]) {
                NameRegisteredViewController *NRVC = [NameRegisteredViewController new];
                NRVC.phoneNumber = registerview.textfield.text;
                [self.navigationController pushViewController:NRVC animated:YES];
            }
        }
    }
    else
    {
        alertCon3 = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertCon3 addAction:okAction];
        [self presentViewController:alertCon3 animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [validationTextField resignFirstResponder];
    
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
