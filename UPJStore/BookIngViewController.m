//
//  BookIngViewController.m
//  UPJStore
//
//  Created by upj on 16/4/12.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "BookIngViewController.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"
#import "AFNetWorking.h"
#import "UIImageView+WebCache.h"
#import "MyAddressViewController.h"
#import "PaySuccessViewController.h"
#import "MBProgressHUD.h"
#import "SelectPayMethohViewController.h"
#import "ChooseCouponViewController.h"



@interface BookIngViewController ()<UITextFieldDelegate>
{
    NSString * addressStr,*areaStr,*aidStr,*mobileStr,*provinceStr,*nameStr,*cityStr;
    UILabel * addressLab,*nameLab,*mobileLab;
    UITextField * Field;
    UIButton * subBtn;
    UIButton * addBtn;
    UITextField *noteField;
    UILabel * PriceLabel;
     NSString * orderID;
    UILabel *NoAddress;
    UIView * address;
    UILabel *couponLabel;
    NSDictionary * couponDic;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@end




@implementation BookIngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    couponDic = @{@"reduce":@"0",@"coupon_code":@"0",@"couponid":@"0",@"title":@"0"};
    
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    self.navigationItem.title = @"确认订单";

    [self initGoodInfo];
    
    [self addressWithDefaul];
    
    [self paymentMethod];
    [self selectCouponBtn];
    [self noteView];
    
    [self endView];
    // Do any additional setup after loading the view.
}
-(void)pop{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)initGoodInfo
{
    UIView * infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, CGFloatMakeY(230))];
    infoView.backgroundColor =  [UIColor whiteColor];
    [self.view addSubview:infoView];
    
    UIImageView * goodSImage = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10, 150, 180)];
    [goodSImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,_modelDic[@"thumb"]]]placeholderImage:[UIImage imageNamed:@"lbtP"]];
    goodSImage.contentMode = UIViewContentModeScaleAspectFit;
    [infoView addSubview:goodSImage];

    
    CGFloat TitleHeight = [_modelDic[@"title"] boundingRectWithSize:CGSizeMake1(414-190, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(14)]} context:nil].size.height;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGFloatMakeX(170), CGFloatMakeY(10),CGFloatMakeY(414-190), TitleHeight)];
    titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = _modelDic[@"title"];
    [infoView addSubview:titleLabel];
    
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake1(170, 170, 150, 20)];
    priceLabel.text = [NSString stringWithFormat:@"价格：¥%@",_modelDic[@"marketprice"]];
    priceLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(14)];
    [infoView addSubview:priceLabel];
    
    UILabel * dispatchLabel = [[UILabel alloc]initWithFrame:CGRectMake1(170+160, 170, 100, 20)];
    if ([_modelDic[@"dispatch"] integerValue]== 0) {
        dispatchLabel.text = @"邮费：包邮";

    }else
    {
        dispatchLabel.text = [NSString stringWithFormat:@"邮费: ¥%@",_modelDic[@"dispatch"]];
    }
    
    dispatchLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(14)];
    [infoView addSubview:dispatchLabel];

    
    
    UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 200, 200, 20)];
    countLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    countLabel.text = @"购买数量";
    [infoView addSubview:countLabel];
    
    
    subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn.frame = CGRectMake1(414-100, 195, 30, 30);
    [subBtn setImage:[UIImage imageNamed:@"product_detail_sub_normal"] forState:UIControlStateNormal];
    [subBtn setImage:[UIImage imageNamed:@"product_detail_sub_no"] forState:UIControlStateDisabled];
    [subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:subBtn];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake1(414-40, 195, 30, 30);
    [addBtn setImage:[UIImage imageNamed:@"product_detail_add_normal"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"product_detail_add_no"] forState:UIControlStateDisabled];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:addBtn];
    
    Field = [[UITextField alloc]initWithFrame:CGRectMake1(414-70, 195, 30, 30)];
    Field.text = @"1";
    Field.layer.borderWidth = 0.1 ;
    Field.delegate = self;
    Field.textAlignment = NSTextAlignmentCenter;
    Field.keyboardType = UIKeyboardTypeNumberPad;
    [infoView addSubview:Field];
    
}

-(void)addressWithDefaul
{
  
    
    address = [[UIView alloc]initWithFrame:CGRectMake1(0, 240, 414, 100)];
    address.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(5, 40, 20, 20)];
    imageView.image = [UIImage imageNamed:@"addImg"];
    
    [address addSubview:imageView];
    [self.view addSubview:address];
    
    UIButton * moreADRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreADRBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    moreADRBtn.frame = CGRectMake1(0, 0, 414, 100);
    [address addSubview:moreADRBtn];
    
    UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(414-20, 40, 20, 20)];
    arrowImageView.image = [UIImage imageNamed:@"箭头"];
    [address addSubview:arrowImageView];
    
    UIImageView * borImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 414, 9)];
    borImageView.image =[UIImage imageNamed:@"biankuang_01"];
    [address addSubview:borImageView];
    
    UIImageView * borImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 91, 414, 9)];
    borImageView1.image =[UIImage imageNamed:@"biankuang_01"];
    [address addSubview:borImageView1];

    nameLab = [[UILabel alloc]initWithFrame:CGRectMake1(40, 20, 354/2, 20)];
    nameLab.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    [address addSubview:nameLab];
    
    mobileLab = [[UILabel alloc]initWithFrame:CGRectMake1(394/2, 20, 354/2, 20)];
    mobileLab.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    mobileLab.textAlignment = NSTextAlignmentRight;
    [address addSubview:mobileLab];
    
    addressLab = [[UILabel alloc]initWithFrame:CGRectMake1(40, 40, 414-60, 50)];
    addressLab.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    addressLab.numberOfLines = 0 ;
    [address addSubview:addressLab];
    
        NoAddress = [[UILabel alloc]initWithFrame:CGRectMake1(40, 9, 414-80, 100-18)];
        NoAddress.text = @"亲，你还没有收货地址喔，点击这里添加。"    ;
    NoAddress.numberOfLines = 0;
    NoAddress.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)addsInfoWithDic:(NSDictionary *)dic
{
    if (_addsDic == nil) {
        [address addSubview:NoAddress];
    }
    else
    {
        [NoAddress removeFromSuperview];
    addressStr  = dic[@"address"];
    areaStr = dic[@"area"];
    cityStr = dic[@"city"];
    aidStr = dic[@"id"];
    mobileStr = dic[@"mobile"];
    provinceStr = dic[@"province"];
    nameStr = dic[@"realname"];
    
    nameLab.text = [NSString stringWithFormat:@"收货人：%@",nameStr];
    mobileLab.text = [NSString stringWithFormat:@"手机号：%@",mobileStr];
    addressLab.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",provinceStr,cityStr,areaStr,addressStr];
    }
    _addsDic = nil;
}

-(void)moreBtnAction:(UIButton *)btn
{
    MyAddressViewController * addVC = [[MyAddressViewController alloc]init];
    
    addVC.isFromDetail =YES;
//    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController pushViewController:addVC animated:YES];
    
}

-(void)paymentMethod
{
    UIView * payMethod = [[UIView alloc]initWithFrame:CGRectMake1(0, 350, 414, 50)];
    payMethod.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payMethod];
    
    UILabel * weChat = [[UILabel alloc]initWithFrame:CGRectMake1(10, 0, 394, 20)];
    weChat.text = @"支付方式";
    weChat.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    [payMethod addSubview:weChat];
    
    UIImageView * weChatImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 20, 30, 30)];
    weChatImageView.image = [UIImage imageNamed:@"绿色logo"];
    weChatImageView.contentMode = UIViewContentModeScaleAspectFit;
    [payMethod addSubview:weChatImageView];
    
    UILabel * weChatLabel = [[UILabel alloc]initWithFrame:CGRectMake1(50, 20, 100, 30)];
    weChatLabel.text = @"微信支付";
    weChatLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    [payMethod addSubview:weChatLabel];
    
    
    UIImageView * AliImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(160, 20, 30, 30)];
    AliImageView.image = [UIImage imageNamed:@"biao"];
    AliImageView.contentMode = UIViewContentModeScaleAspectFit;
    [payMethod addSubview:AliImageView];
    
    UILabel * AliLabel = [[UILabel alloc]initWithFrame:CGRectMake1(200, 20, 100, 30)];
    AliLabel.text = @"支付宝支付";
    AliLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    [payMethod addSubview:AliLabel];

    
}

-(void)selectCouponBtn
{
    UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake1(0, 410, 414, 40)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    
    UIButton * couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponBtn addTarget:self action:@selector(selectCouponAction:) forControlEvents:UIControlEventTouchUpInside];
    couponBtn.frame = CGRectMake1(0, 0, 414, 40);
    [selectView addSubview:couponBtn];
    
//#warning  添加提示语 需要加入属性
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(5, 5, 100, 30)];
    titleLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(15)];
    titleLabel.text = @"优惠券";
    [selectView addSubview:titleLabel];
    
    
    couponLabel = [[UILabel alloc]initWithFrame:CGRectMake1(105, 5, 274, 30)];
    couponLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    couponLabel.textAlignment = NSTextAlignmentRight;
    [self couponText];
    [selectView addSubview:couponLabel];
    
    UIImageView * AddImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(379, 5, 30, 30)];
    AddImageView.image = [UIImage imageNamed:@"addCoupon"];
    AddImageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectView addSubview:AddImageView];
}

-(void)couponText
{
    if (_couponStr == nil) {
        couponLabel.text  = @"兑换优惠券";
    }else
    {
        couponLabel.text = _couponStr;
    }
    
}

-(void)noteView
{
    UIView * noteView = [[UIView alloc]initWithFrame:CGRectMake1(0, 460, 414, 150)];
    noteView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:noteView];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 0, 394, 30)];
    headLabel.text = @"备注信息：";
    headLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    [noteView addSubview:headLabel];
    
    noteField = [[UITextField alloc]initWithFrame:CGRectMake1(10, 30, 394, 120)];
    noteField.delegate =self;
    noteField.placeholder = @"亲，还有什么要交代的话，告诉我们吧！";
    
    [noteView addSubview:noteField];
}



-(void)endView
{
    UIView * endView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-64-CGFloatMakeY(60), kWidth, CGFloatMakeY(60) )];
    endView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:endView];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 10, 50, 40)];
    totalLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(15)];
    totalLabel.text = @"合计：";
    [endView addSubview:totalLabel];
    
    PriceLabel = [[UILabel alloc]initWithFrame:CGRectMake1(60, 10, 100, 40)];
    PriceLabel.font =[UIFont systemFontOfSize:CGFloatMakeY(15)];
    PriceLabel.text = [NSString stringWithFormat:@"¥%.2f元",[_modelDic[@"marketprice"] floatValue]+[_modelDic[@"dispatch"] floatValue]];
    PriceLabel.textColor = [UIColor colorFromHexRGB:@"cc2245"];
    [endView addSubview:PriceLabel];
    
    UIButton * makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    makeSureBtn.frame =CGRectMake1(414-160, 10, 150, 40);
    [makeSureBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
    makeSureBtn.layer.cornerRadius = 5;
    [makeSureBtn addTarget:self action:@selector(postData:) forControlEvents:UIControlEventTouchUpInside];
    makeSureBtn.backgroundColor = [UIColor colorFromHexRGB:@"cc2245"];
    [endView addSubview:makeSureBtn];
    
    
}

-(void)postData:(UIButton *)btn
{
    
    if (aidStr == nil)
    {
        MyAddressViewController * addVC = [[MyAddressViewController alloc]init];
        
        addVC.isFromDetail =YES;
        //    self.navigationController.navigationBar.translucent = NO;
        
        [self.navigationController pushViewController:addVC animated:YES];
        

    }
    else
    {
        [self setMBHUD];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlePayResult:) name:WX_PAY_RESULT object:nil];
        
        NSDictionary * dic =@{@"appkey":APPkey,@"mid":[self returnMid],@"aid":aidStr,@"id":_modelDic[@"DetailID"],@"total":Field.text,@"remark":noteField.text,@"coupon_code":couponDic[@"coupon_code"],@"couponid":couponDic[@"couponid"]};
#pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:dic];
        
        AFHTTPSessionManager * manager = [self sharedManager];;
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

        
        [manager POST:kSubmit parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DLog(@"%@",responseObject);
            
            
            NSDictionary * dic = responseObject;
            orderID = dic[@"order_id"];
            SelectPayMethohViewController *selectVC = [[SelectPayMethohViewController alloc]init];
            selectVC.orderID = orderID;
            
            selectVC.totalPrice = [NSString stringWithFormat:@"%.2f",[[self totalPrice] floatValue]-[couponDic[@"reduce"] floatValue]+[_modelDic[@"dispatch"] floatValue]];
            
            [self.navigationController pushViewController:selectVC animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            DLog(@"error : %@",error);
            
        }];

    }
    
    
}

-(NSString*)totalPrice
{
    float count =[Field.text floatValue];
    float count2 =[_modelDic[@"marketprice"] floatValue];
    
    NSString *totalPrice = [NSString stringWithFormat:@"%.2f",count*count2];

    return totalPrice;
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

- (void)handlePayResult:(NSNotification *)noti
{
    DLog(@"Notifiction Object : %@",noti.object);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"支付结果" message:[NSString stringWithFormat:@"%@",noti.object] preferredStyle:UIAlertControllerStyleActionSheet];
    if ([noti.object isEqualToString:@"成功"]) {
        
        //添加按钮
            PaySuccessViewController *success = [[PaySuccessViewController alloc]init];
            
            success.orderId = orderID;
            
            [self.navigationController pushViewController:success animated:YES];
            
        
    }
    else
    {
        //添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"重新支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self postData:nil];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

        
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_addsDic == nil) {
        
        for (NSDictionary * dic in [self returnAddress]) {
            if ([dic[@"isdefault"]isEqualToString:@"1"]) {
                _addsDic = [NSDictionary dictionaryWithDictionary:dic];
            }
        }
        
    }
    if (_loadingHud != nil) {
        [_loadingHud setHidden:YES];
        _loadingHud = nil;
    }
    
    [self addsInfoWithDic:_addsDic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduce:) name:@"reduce" object:nil];


}

-(void)reduce:(NSNotification *)reduce
{
    couponDic = reduce.userInfo;
    PriceLabel.text = [NSString stringWithFormat:@"¥%.2f元", [[self totalPrice] floatValue]-[couponDic[@"reduce"] floatValue]];
    couponLabel.text = couponDic[@"title"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reduce" object:nil];
}


-(void)subAction:(UIButton *)btn
{
    addBtn.enabled = YES;
    if ([Field.text integerValue]>1) {
        btn.enabled =YES;
 
        Field.text = [NSString stringWithFormat:@"%ld",[Field.text integerValue]-1];
        PriceLabel.text =[NSString stringWithFormat:@"¥%.2f元",([Field.text integerValue])*[(NSString *)_modelDic[@"marketprice"] floatValue]];
    }else
    {
        btn.enabled = NO;

    }
    
}


-(void)addAction:(UIButton *)btn
{
    subBtn.enabled =YES;
    couponDic = @{@"reduce":@"0",@"coupon_code":@"0",@"couponid":@"0",@"title":@"0"};
    couponLabel.text = @"兑换优惠券";
    if ([Field.text integerValue]<99) {
        btn.enabled =YES;
        Field.text = [NSString stringWithFormat:@"%ld",[Field.text integerValue]+1];
               PriceLabel.text =[NSString stringWithFormat:@"¥%.2f元",([Field.text integerValue])*[(NSString *)_modelDic[@"marketprice"] floatValue]];
    }else
    {
        btn.enabled = NO;
    }
    
}
#pragma mark - 屏幕上弹
-( void )textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -170.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}

#pragma mark -屏幕恢复
-( void )textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == Field)
    {
        if ([textField.text integerValue] > 99) {
            textField.text = @"99";
        }
        if ([textField.text integerValue] == 0) {
            textField.text = @"1";
        }
        
    }
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 64.f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
    [UIView commitAnimations];
}

-(void)selectCouponAction:(UIButton *)btn
{
    ChooseCouponViewController * chooseVC = [[ChooseCouponViewController alloc]init];
   
    chooseVC.dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"amount":[self totalPrice]};
    [self.navigationController pushViewController:chooseVC animated:YES];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Field resignFirstResponder];
    [noteField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [Field resignFirstResponder];
    [noteField resignFirstResponder];
    return YES;
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
