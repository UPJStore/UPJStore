//
//  DealerSettingViewController.m
//  UPJStore
//
//  Created by upj on 16/9/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "DealerSettingViewController.h"
#import "UIViewController+CG.h"

@interface DealerSettingViewController ()
@property(nonatomic,strong)UITextField * nameField;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation DealerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorFromHexRGB:@"f6f6f6"];
    self.navigationItem.title = @"店铺设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self initWithTextfield];
    
}

-(void)initWithTextfield
{
    UIView * fieldView = [[UIView alloc]initWithFrame:CGRectMake1(0, 20, 414, 50)];
    fieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fieldView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [fieldView addSubview:lineView];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake1(0, 50, 414, 1)];
    lineView3.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [fieldView addSubview:lineView3];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 100, 50)];
    namelabel.text = @"店铺名字";
    namelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    namelabel.textAlignment = 1;
    [fieldView addSubview:namelabel];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake1(100, 0, 314, 50)];
    _nameField.placeholder = @"请输入你想要的店铺名字";
    _nameField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [fieldView addSubview:_nameField];
    
    [self initWithBtn];
}

-(void)initWithBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake1(30, 90, 354, 50);
    button.backgroundColor = [UIColor colorFromHexRGB:@"32a632"];
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = CGFloatMakeY(8);
    button.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)btnAction
{
    AFHTTPSessionManager * manager = [self sharedManager];;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary * dic =@{@"appkey":APPkey,@"member_id":[self returnMid],@"name":_nameField.text};
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:KChangeShopName parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"errcode"]];
        if ([str isEqualToString:@"1"]) {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hide) userInfo:nil repeats:NO];
            [self presentViewController:alert1 animated:YES completion:nil];
        }else
        {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"修改失败,请重试" preferredStyle:UIAlertControllerStyleAlert];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hide2) userInfo:nil repeats:NO];
            [self presentViewController:alert1 animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"errer %@",error);
    }];

}

-(void)hide
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [_timer invalidate];
    _timer = nil;
}

-(void)hide2
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [_timer invalidate];
    _timer = nil;
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
