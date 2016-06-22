
//
//  ModifyRealnameViewController.m
//  UPJStore
//
//  Created by upj on 16/5/25.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ModifyRealnameViewController.h"
#import "UIViewController+CG.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ModifyRealnameViewController ()
{
    UITableView *modifyTableView;
    UITextField *textField;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@end

@implementation ModifyRealnameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"真实姓名修改";
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui_@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    self.view.backgroundColor = backcolor;
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake1(0, 0.5, 414, 50)];
    textField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if(![[self returnRealName] isEqualToString:@"0"])
    {
         textField.text = [self returnRealName];
    }
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:textField];
}

-(void)save
{
    [self setMBHUD];
    [self updateRealname];
}

-(void)updateRealname
{
    NSDictionary *dic = @{@"appkey":APPkey,@"realname":textField.text,@"mid":[self returnMid]};
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //发送请求
    [manager POST:kUpdate parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
        [self setNamewithRealName:textField.text];
        [self pop];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
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
