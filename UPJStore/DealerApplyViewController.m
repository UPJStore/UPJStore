//
//  DealerApplyViewController.m
//  UPJStore
//
//  Created by upj on 16/9/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "DealerApplyViewController.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@interface DealerApplyViewController ()
@property(nonatomic,strong)UIView *fieldView;
@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *numberField;
@end

@implementation DealerApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorFromHexRGB:@"f0f0f0"];
    self.navigationItem.title = @"开店申请";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self initWithTextfield];
}

-(void)initWithTextfield
{
    _fieldView = [[UIView alloc]initWithFrame:CGRectMake1(0, 10, 414, 100)];
    _fieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_fieldView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_fieldView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(10, 50, 394, 1)];
    lineView2.backgroundColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_fieldView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake1(0, 99, 414, 1)];
    lineView3.backgroundColor = [UIColor colorFromHexRGB:@"dddddd"];
    [_fieldView addSubview:lineView3];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 100, 50)];
    namelabel.text = @"姓名";
    namelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    namelabel.textAlignment = 1;
    [_fieldView addSubview:namelabel];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake1(100, 0, 314, 50)];
    _nameField.placeholder = @"店主姓名";
    _nameField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_fieldView addSubview:_nameField];
    
    UILabel *numberlabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 50, 100, 50)];
    numberlabel.textAlignment = 1;
    numberlabel.text = @"手机号码";
    numberlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_fieldView addSubview:numberlabel];
    
    _numberField = [[UITextField alloc]initWithFrame:CGRectMake1(100, 50, 314, 50)];
    _numberField.placeholder = @"店主手机号码";
    _numberField.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [_fieldView addSubview:_numberField];
    
    [self initWithLabel];
}

-(void)initWithLabel
{
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake1(0, 120, 414, 500)];
    labelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelView];
    
    UILabel *textLabel1 = [[UILabel alloc]initWithFrame:CGRectMake1(16, 0, 374, 20)];
    textLabel1.text = @"【项目合作优势】：";
    textLabel1.textColor = [UIColor blackColor];
    textLabel1.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [labelView addSubview:textLabel1];
    
    UILabel *textLabel2 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 20, 374, 160)];
    textLabel2.numberOfLines = 0;
    textLabel2.text = @"1、高利润—完税商品40%以上高利润，跨境商品纯利20%以上。\n2、送客源—免费获得友品集•全球购物平台 千万流量定向分配。并能扩散无限分销资源。\n3、免税商品—首批1300个纯国外知名爆品，年度产品SKU总数突破2500。全品牌一手货源自采，产品全自营，保税发货，安全可靠。\n4、完税商品—完税进口商品100%保真，证件齐备。首批超3000个SKU。\n5、国家政策支持— 友品集•全球购企业自身为中国海关特批的跨境电商购物平台。\n6、超强运营实力—拥有30年线下及电商运营经验积累，香港连锁店运营总监带领运营团队/千万级项目实战资金。";
    textLabel2.textColor = [UIColor colorFromHexRGB:@"aaaaaa"];
    textLabel2.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [labelView addSubview:textLabel2];
    
    UILabel *textLabel3 = [[UILabel alloc]initWithFrame:CGRectMake1(16, 190, 374, 20)];
    textLabel3.text = @"【开店费用只需365元】：";
    textLabel3.textColor = [UIColor blackColor];
    textLabel3.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [labelView addSubview:textLabel3];
    
    UILabel *textLabel4 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 210, 374, 160)];
    textLabel4.text = @"1、完税进口商品	完税进口商品（友品集•全球购 采购价）\n2、跨境商品	自拍跨境商品（含物流费与清关费）\n3、专属域名	1个分享专属域名   （价值365元）\n4、商城（价值3000元）\nA. 应用于微信使用的【友品集•全球购】专属分店端口一个（内带：分享、传播二维码等用途的功能）\n5、商城引流支持	友品集•全球购物平台 千万流量定向分配。并能扩散无限分销资源。   (价值5000元)\n\n全部总价值	  12015元";
    textLabel4.numberOfLines = 0;
    textLabel4.textColor = [UIColor colorFromHexRGB:@"aaaaaa"];
    textLabel4.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [labelView addSubview:textLabel4];
    
    UIButton *ApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ApplyBtn.frame = CGRectMake1(30, 400, 354, 50);
    ApplyBtn.backgroundColor = [UIColor colorFromHexRGB:@"32a632@"];
    [ApplyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [ApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ApplyBtn.layer.cornerRadius = CGFloatMakeY(8);
    ApplyBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [ApplyBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [labelView addSubview:ApplyBtn];
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
