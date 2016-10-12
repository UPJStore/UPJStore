//
//  AppleConfirmViewController.m
//  UPJStore
//
//  Created by upj on 16/10/10.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ApplyConfirmViewController.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"

@interface ApplyConfirmViewController ()

@end

@implementation ApplyConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorFromHexRGB:@"f6f6f6"];
    self.navigationItem.title = @"确认订单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self initWithLabel];
}

-(void)initWithLabel
{
    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake1(0, 10, 414, 50)];
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [typeView addSubview:lineView];
    
    UIView *lineView0 = [[UIView alloc]initWithFrame:CGRectMake1(0, 49, 414, 1)];
    lineView0.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [typeView addSubview:lineView0];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 80, 50)];
    label1.text = _dic[@"type"];
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [typeView addSubview:label1];
    
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake1(100, 0, 250, 50)];
    if ([_dic[@"type"]isEqualToString:@"蚂蚁经纪人"]) {
        label11.text = @"365元";
    }else if ([_dic[@"type"]isEqualToString:@"经销商"])
    {
        label11.text = @"2000元";
    }
    label11.textAlignment = 2;
    label11.textColor = [UIColor colorFromHexRGB:@"aaaaaa"];
    [typeView addSubview:label11];
    
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake1(0, 65, 414, 150)];
    labelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labelView];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(10, 50, 394, 1)];
    lineView2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake1(10, 99, 394, 1)];
    lineView3.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView3];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake1(0, 149, 414, 1)];
    lineView4.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
    [labelView addSubview:lineView4];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 80, 50)];
    namelabel.text = @"姓名";
    namelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    namelabel.textAlignment = 0;
    [labelView addSubview:namelabel];
    
    UILabel* nameField = [[UILabel alloc]initWithFrame:CGRectMake1(100, 0, 314, 50)];
    nameField.text = _dic[@"name"];
    nameField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:nameField];
    
    UILabel *numberlabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 50, 80, 50)];
    numberlabel.textAlignment = 0;
    numberlabel.text = @"手机号码";
    numberlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:numberlabel];
    
    UILabel * numberField = [[UILabel alloc]initWithFrame:CGRectMake1(100, 50, 314, 50)];
    numberField.text = _dic[@"phone"];
    numberField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:numberField];
    
    UILabel *recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake1(20, 100, 80, 50)];
    recommendLabel.textAlignment = 0;
    recommendLabel.text = @"推荐人";
    recommendLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:recommendLabel];
    
    UILabel* recommendLabel2 = [[UILabel alloc]initWithFrame:CGRectMake1(100, 100, 314, 50)];
    recommendLabel2.text = _dic[@"recommend"];
    recommendLabel2.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [labelView addSubview:recommendLabel2];
    
    [self initWithButton];
}

-(void)initWithButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake1(20, 235, 374, 50);
    btn.backgroundColor = [UIColor colorFromHexRGB:@"32a632@"];
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = CGFloatMakeY(8);
    btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
