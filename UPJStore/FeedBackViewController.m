//
//  feedbackViewController.m
//  UPJStore
//
//  Created by upj on 16/3/11.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UIViewController+CG.h"

#define Limit_Number 200

@interface FeedBackViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView * feedbackTextView;
@property (nonatomic,strong)UILabel *headLabel ;
@property (nonatomic,strong) UILabel *showCountLabel;
@property (nonatomic,strong) NSString *numberStr;
@property (nonatomic,strong)UITextField * contactView;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    self.view.backgroundColor = backcolor;
    
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(tapAction:)];
    
    _feedbackTextView = [[UITextView alloc]initWithFrame:CGRectMake1(13, 11, 388, 129)];
    _feedbackTextView.delegate =self;
    [_feedbackTextView.layer setCornerRadius:5];
    _feedbackTextView.textAlignment = NSTextAlignmentLeft;
    _feedbackTextView.backgroundColor = [UIColor whiteColor];
    _feedbackTextView.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    
    //取消iOS7的边缘延伸效果（例如导航栏，状态栏等等）
    //  self.modalPresentationCapturesStatusBarAppearance = NO;
    //  self.edgesForExtendedLayout = UIRectEdgeNone;
    // self.extendedLayoutIncludesOpaqueBars = NO;
    
    [self.view addSubview:_feedbackTextView];
    
    UITextField * contactView = [[UITextField alloc]initWithFrame:CGRectMake1(13, 151, 388, 42)];
    contactView.backgroundColor = [UIColor whiteColor];
    [contactView.layer setCornerRadius:5];
    contactView.placeholder = @"你的联系方式（选填）";
    contactView.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [self.view addSubview:contactView];
    _numberStr = [NSString stringWithFormat:@"0/%d",Limit_Number];
    [self initLabel];
    
}


-(void)initLabel
{
    _headLabel = [[UILabel alloc]initWithFrame:CGRectMake1(6, 6, 388*3/4, 20)];
    _headLabel.text = @"请尽可能详细地写出你的意见";
    _headLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    UIColor *holdcolor = [UIColor colorWithWhite:0.75 alpha:1];
    _headLabel.textColor = holdcolor;
    [_feedbackTextView addSubview:_headLabel];
    
    _showCountLabel = [[UILabel alloc]initWithFrame:CGRectMake1(339,119, 56, 15)];
    _showCountLabel.text = _numberStr;
    _showCountLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    _showCountLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_showCountLabel];
    
}


-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

//回收键盘。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textViewDidChange:(UITextView *)textView
{    _headLabel.hidden =YES;
    _numberStr = [NSString stringWithFormat:@"%ld/200",_feedbackTextView.text.length];
    _showCountLabel.text = _numberStr;
    if (_feedbackTextView.text.length ==0) {
        _headLabel.hidden = NO;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //限定输入字数（有联想的输入）
    if (_feedbackTextView.text.length > Limit_Number)
    {
        _feedbackTextView.text = [textView.text substringToIndex:Limit_Number];
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限定输入字数
    NSString *str = [NSString stringWithFormat:@"%@%@", _feedbackTextView.text, text];
    if (str.length > Limit_Number)
    {
        _feedbackTextView.text = [_feedbackTextView.text substringToIndex:Limit_Number];
        return NO;
    }
    
    return YES;
}

-(void)tapAction:(UIButton*)btn
{
    [self setMBHUD];
    if (_contactView.text.length !=0) {
        NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"remark":_feedbackTextView.text,@"contact":_contactView.text};
        [self postDataWith:dic];
    }else{
        NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"remark":_feedbackTextView.text};
        [self postDataWith:dic];
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
    [manager POST:kEvaluate parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
        UIAlertController *alertCon2 = [UIAlertController alertControllerWithTitle:nil message:@"反馈成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertCon2 addAction:okAction];
        [self presentViewController:alertCon2 animated:YES completion:nil];
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
    self.navigationController.navigationBar.translucent = NO;
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
