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
@property(nonatomic,strong)UITextField * numberField;
@end

@implementation DealerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorFromHexRGB:@"f6f6f6"];
    self.navigationItem.title = @"开店申请";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self initWithTextfield];
    
}

-(void)initWithTextfield
{
    UIView * fieldView = [[UIView alloc]initWithFrame:CGRectMake1(0, 10, 414, 100)];
    fieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fieldView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [fieldView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(10, 50, 394, 1)];
    lineView2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [fieldView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake1(0, 99, 414, 1)];
    lineView3.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [fieldView addSubview:lineView3];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 100, 50)];
    namelabel.text = @"姓名";
    namelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    namelabel.textAlignment = 1;
    [fieldView addSubview:namelabel];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake1(100, 0, 314, 50)];
    _nameField.placeholder = @"店主姓名";
    _nameField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [fieldView addSubview:_nameField];
    
    UILabel *numberlabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 50, 100, 50)];
    numberlabel.textAlignment = 1;
    numberlabel.text = @"手机号码";
    numberlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [fieldView addSubview:numberlabel];
    
    _numberField = [[UITextField alloc]initWithFrame:CGRectMake1(100, 50, 314, 50)];
    _numberField.placeholder = @"店主手机号码";
    _numberField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [fieldView addSubview:_numberField];
 
    [self initWithBtn];
}

-(void)initWithBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake1(30, 140, 354, 50);
    button.backgroundColor = [UIColor colorFromHexRGB:@"32a632"];
    [button setTitle:@"提交申请" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = CGFloatMakeY(8);
    button.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)btnAction
{
    
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
