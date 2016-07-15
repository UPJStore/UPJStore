//
//  NameRegisteredViewViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "NameRegisteredViewController.h"
#import "TextFieldView.h"
#import "UIViewController+CG.h"
#import "AgreementViewController.h"
#import "MBProgressHUD.h"

#define widthSize 414.0/320
#define hightSize 736.0/568

@interface NameRegisteredViewController ()
{
    TextFieldView *userTextFieldView;
    TextFieldView *nameTextFieldView;
    TextFieldView *passwordTextFieldView;
    UISwitch *passwordSwitch;
    TextFieldView *passwordTextFieldView2;
    //  TextFieldView *idcardTextFieldView;
    UISwitch *passwordSwitch2;
    UIButton *nextBtn;
    UILabel *label;
    UIButton *label2;
    UIAlertController *alertCon;
    NSString *errcode;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;

@end

@implementation NameRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    self.view.backgroundColor = backcolor;
    
    self.navigationItem.title = @"注册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    nameTextFieldView = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 0, 414, 736) String:@"昵称" picture:@"membericon" number:414];
    [self.view addSubview:nameTextFieldView];
    
    passwordTextFieldView = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 65, 414, 736) String:@"6-18位的英文或数字的密码" picture:@"code" number:414];
    [passwordTextFieldView passwordHide];
    [self.view addSubview:passwordTextFieldView];
    
    passwordSwitch =[[UISwitch alloc]initWithFrame:CGRectMake1(316, 86, 39, 26)];
    [passwordSwitch addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    passwordSwitch.tag = 1;
    [self.view addSubview:passwordSwitch];
    [passwordTextFieldView addRightView:passwordSwitch];
    
    passwordTextFieldView2 = [[TextFieldView alloc]initWithFrame:CGRectMake1(0, 130, 414, 736) String:@"重复密码" picture:@"code" number:414];
    [passwordTextFieldView2 passwordHide];
    [self.view addSubview:passwordTextFieldView2];
    
    passwordSwitch2 =[[UISwitch alloc]initWithFrame:CGRectMake1(316, 151, 39, 26)];
    [passwordSwitch2 addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    passwordSwitch2.tag = 2;
    [self.view addSubview:passwordSwitch2];
    [passwordTextFieldView2 addRightView:passwordSwitch2];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake1(26, 215, 362, 51);
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    nextBtn.backgroundColor = btncolor;
    [nextBtn.layer setCornerRadius:5.0];
    [nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake1(101,273 ,160,12)];
    label.text = @"立即注册表示你同意友品集的";
    label.textAlignment = 2;
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    label.textColor = fontcolor;
    [self.view addSubview:label];
    
    label2 = [[UIButton alloc]initWithFrame:CGRectMake1(260,273, 52, 12)];
    [label2 setTitle:@"用户协议" forState:UIControlStateNormal];
    label2.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [label2 setTitleColor:btncolor forState:UIControlStateNormal];
    label2.titleLabel.textAlignment = 0;
    [label2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:label2];
    
}

-(void)tapAction:(UIButton*)btn
{
    AgreementViewController *AGVC = [AgreementViewController new];
    [self.navigationController pushViewController:AGVC animated:YES];
}

//- (BOOL)checkUserIdCard: (NSString *) idCard
//{
//    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:idCard];
//    return isMatch;
//}

- (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^[0-9_a-zA-Z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

- (BOOL)checkuserName:(NSString *)userName
{
    //  NSString *pattern = @"^{1,20}$";
    //  NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    // BOOL isMatch = [pred evaluateWithObject:userName];
    BOOL isMatch  = NO;
    if (userName.length>0&&userName.length<20) {
        isMatch = YES;
    }
    return isMatch;
}

-(BOOL)checkPasswordAgain
{
    return [passwordTextFieldView.textfield.text isEqualToString:passwordTextFieldView2.textfield.text];
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
    if ([self checkuserName:nameTextFieldView.textfield.text]) {
        if ([self checkPassword:passwordTextFieldView.textfield.text])
        {
            if ([self checkPasswordAgain]) {
                //进行注册
                [self setMBHUD];
                NSDictionary *dic = @{@"uname":_phoneNumber,@"pwd":passwordTextFieldView.textfield.text,@"nickname":nameTextFieldView.textfield.text,@"appkey":APPkey};
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
    else
    {
        alertCon = [UIAlertController alertControllerWithTitle:nil message:@"请输入20位以内的昵称" preferredStyle:UIAlertControllerStyleAlert];
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
    //传入的参数
    //发送请求
    [manager POST:kRegister parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
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
            alertCon = [UIAlertController alertControllerWithTitle:nil message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
            }];
            [alertCon addAction:okAction];
            [self presentViewController:alertCon animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    self.navigationController.navigationBar.translucent =NO;
}

#pragma mark -- 加载动画
-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the custom view mode to show any view.
    /*
     _loadingHud.mode = MBProgressHUDModeCustomView;
     UIImage *gif = [UIImage sd_animatedGIFNamed:@"youpinji"];
     
     UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
     _loadingHud.customView = gifView;
     */
    _loadingHud.bezelView.backgroundColor = [UIColor clearColor];
    _loadingHud.animationType = MBProgressHUDAnimationFade;
    _loadingHud.backgroundColor = [UIColor whiteColor];
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
/*
 CG_INLINE CGRect
 CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
 {
 //先得到appdelegate
 AppDelegate *app= [UIApplication sharedApplication].delegate;
 
 CGRect rect;
 //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
 rect.origin.x = x*app.autoSizeScaleX;//原点的X坐标的改变
 rect.origin.y = y;//原点的Y坐标的改变
 rect.size.width = width*app.autoSizeScaleX;//宽的改变
 rect.size.height = height*app.autoSizeScaleY;//高的改变
 return rect;
 }
 */
@end

