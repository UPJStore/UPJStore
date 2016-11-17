//
//  MemberCenterViewController.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/16.
//  Copyright © 2016年 UPJApp. All rights reserved.
//



#import "MemberCenterViewController.h"
#import "MemberTableViewCell.h"
#import "PerInfView.h"
#import "LoginViewController.h"
#import "HeaderView.h"
#import "OrderViewController.h"
#import "MyCookieViewController.h"
#import "MyCollectViewController.h"
#import "MyAttentionViewController.h"
#import "AboutUPJViewController.h"
#import "FeedbackViewController.h"
#import "PhoneRegisteredViewController.h"
#import "MyCouponViewController.h"
#import "MyAddressViewController.h"
#import "MemberModel.h"
#import "UIViewController+CG.h"
#import "SettingViewController.h"
#import "CouponModel.h"
#import "CKListViewController.h"
#import "AgentsViewController.h"
#import "AgentViewController.h"
#import "UIButton+WebCache.h"
#import "CommissonWithdrawalViewController.h"
#import "DealerApplyViewController.h"
#import "DealerSettingViewController.h"
#import "MyShopViewController.h"
#import "ShopExpandViewController.h"
#import "MyCodeViewController.h"

#define widthSize 414.0/320
#define hightSize 736.0/568
@interface MemberCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LoginAciton,login,logout,sendModel,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView * memberView;
@property (nonatomic,strong) NSArray *arr1;
@property (nonatomic,strong) NSArray *arr2;
@property (nonatomic,strong) NSArray *arr3;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HeaderView * headerView;
@property (nonatomic,strong) NSString *imageStr;
@property (nonatomic,strong) NSString *domain_level;

@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.delegate = self;
    
    self.mid = [self returnMid];
    self.islogin = [self returnIsLogin];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    
    _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券"];
    if (self.islogin) {
        //先判断是创客还是经销商
        if([self returnIsDealer])
        {
            _arr2 = @[@"店铺二维码",@"我的分店",@"利润提现",@"我的店铺",@"蚁店推广",@"店铺设置",@"授权二维码"];
            _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
        }else if ([self returnIsFlag])
        {
            _arr2 = @[@"我的二维码",@"我的会员",@"佣金提现"];
            _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
        }else
        {
            _arr2 = @[];
            _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
        }
        if ([self returnIsAgent]) {
            _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券",@"代理商入口"];
            _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
        }
    }else
    {
        _arr2 = @[];
        _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
    }
    _headerView = [[HeaderView alloc]initWithFrame:CGRectMake1(0, 0, 414, 147) withIsLogin:self.islogin withname:[self returnNickName]];
    UIImageView *bgimgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing1.jpg"]];
    bgimgView.frame = CGRectMake1(0, 0, 414, 147);
    [_headerView addSubview:bgimgView];
    [_headerView sendSubviewToBack:bgimgView];
    _headerView.delegate = self;
    _headerView.imageBtn.userInteractionEnabled = YES;
    [_headerView.imageBtn addTarget:self action:@selector(changeHeaderImg) forControlEvents:UIControlEventTouchUpInside];
    if ([self returnIsLogin]) {
        [_headerView.imageBtn setImage:[UIImage imageWithData:[self returnImageData]] forState:UIControlStateNormal];
        [self postmid];
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [self.scrollView addSubview:_headerView];
    
    
    _memberView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 160,414, 55*(_arr1.count+_arr2.count+_arr3.count)+150) style:UITableViewStylePlain];
    _memberView.delegate =self;
    _memberView.dataSource = self;
    _memberView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
    [_memberView registerClass:[MemberTableViewCell class] forCellReuseIdentifier:@"memberCell"];
    _memberView.scrollEnabled = NO;
    
    [self.scrollView addSubview:_memberView];
    [_memberView reloadData];
    //  [self.scrollView addSubview:perinfView];
    
    _scrollView.contentSize = CGSizeMake(kWidth,_memberView.frame.origin.y+_memberView.frame.size.height+CGFloatMakeY(86));
    _scrollView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view.
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 0;
    }
    else if(section == 1)
    {
        return _arr1.count;
    }else if (section == 2)
    {
        return _arr2.count;
    }else
    {
        return _arr3.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"memberCell";
    MemberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[MemberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    NSArray *arr = [NSArray new];
    NSString *str = [NSString new];
    if (indexPath.section == 1) {
        arr = [NSArray arrayWithArray:_arr1];
        str = @"member";
    }else if (indexPath.section == 2)
    {
        arr = [NSArray arrayWithArray:_arr2];
        str = @"CK";
    }else if(indexPath.section == 3)
    {
        arr = [NSArray arrayWithArray:_arr3];
        str = @"protocol";
    }
    cell.titleLabel.text = arr[indexPath.row];
    
    if (indexPath.section == 3) {
        if ([self returnIsAgent]||[self returnIsDealer]) {
            cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",str,(long)indexPath.row+1]];
        }else
        {
            cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",str,(long)indexPath.row]];
        }
    }else
    {
        cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",str,(long)indexPath.row]];
    }
    
    //ImageView 自适应。
    cell.iconView.contentMode = UIViewContentModeScaleAspectFit;
    cell.arrowView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(55);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

#pragma 2016年04月08日15:59:16 修改 图片路径 修改iconView大小
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake1(0, 0, 414, 55);
        orderBtn.tag = 0;
        [orderBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:orderBtn];
        
        UIImageView *iconView1 = [[UIImageView alloc]initWithFrame:CGRectMake1(20, 20, 20, 20)];
        iconView1.image = [UIImage imageNamed:@"MyOrder"];
        iconView1.contentMode = UIViewContentModeScaleAspectFit;
        [orderBtn addSubview:iconView1];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(60, 20, 300, 20)];
        titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        titleLabel.text = @"我的订单";
        [orderBtn addSubview:titleLabel];
        
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake1(370, 20, 30, 20)];
        arrowView.image = [UIImage imageNamed:@"rightArrow"];
        arrowView.contentMode = UIViewContentModeScaleAspectFit;
        [orderBtn addSubview:arrowView];
        
        NSArray *arr = @[@"待付款",@"待发货",@"待收货",@"待评价"];
        for (int i = 0; i <4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 45, k6PWidth/4, 10)];
            label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = arr[i];
            [btn addSubview:label];
            
            btn.frame = CGRectMake1(k6PWidth/4*i,55, k6PWidth/4, 70);
            btn.tag = i+1;
            [btn addTarget:self action:@selector(btnAction:)
          forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 10, 33, 33)];
            iconView.center = CGPointMake(btn.frame.size.width/2,(iconView.frame.origin.y+iconView.frame.size.height)/2);
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            
            iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dingdan%d",i]];
            [btn addSubview:iconView];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 54, 414, 1)];
            lineView.backgroundColor = [UIColor colorFromHexRGB:@"e0e0e0"];
            [view addSubview:lineView];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 119, 414, 1)];
            lineView2.backgroundColor = [UIColor colorFromHexRGB:@"e0e0e0"];
            [view addSubview:lineView2];
            
            
        }
        return view;
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section  == 0) {
        return CGFloatMakeY(120);
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!_islogin) {
            return 0;
        }else if (![self returnIsFlag]) {
            if (![self returnIsDealer]) {
                return 0;
            }else
            {
                return CGFloatMakeY(10);
            }
        }else
        {
            return CGFloatMakeY(10);
        }
    }else{
        return CGFloatMakeY(10);
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 10)];
    UIColor *backcolor = [UIColor colorFromHexRGB:@"f6f6f6"];
    view.backgroundColor = backcolor;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if(_islogin){
            switch (indexPath.row) {
                case 0:
                {
                    MyCollectViewController *MCVC = [MyCollectViewController new];
                    MCVC.mid = self.mid;
                    [self.navigationController pushViewController:MCVC animated:YES];
                }
                    break;
                case 1:
                {
                    MyAttentionViewController *MAVC = [MyAttentionViewController new];
                    [self.navigationController pushViewController:MAVC animated:YES];
                }
                    break;
                case 2:
                {
                    MyAddressViewController *myaddressVC = [MyAddressViewController new];
                    [self.navigationController pushViewController:myaddressVC animated:YES];
                }
                    break;
                case 3:
                {
                    MyCouponViewController *mycouponVC = [MyCouponViewController new];
                    mycouponVC.mid = self.mid;
                    [self.navigationController pushViewController:mycouponVC animated:YES];
                }
                    break;
                case 4:
                {
                    AgentViewController *AVC = [[AgentViewController alloc]init];
                    [self.navigationController pushViewController:AVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }else
        {
            [self loginAction:nil];
        }
    }
    if(indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                MyCodeViewController *MCVC = [MyCodeViewController new];
                MCVC.isShare = NO;
                [self.navigationController pushViewController:MCVC animated:YES];
            }
                break;
            case 1:
            {
                CKListViewController *CKVC = [CKListViewController new];
                CKVC.domain_level = _domain_level;
                if([self returnIsDealer])
                {
                    CKVC.isCk = NO;
                }else
                {
                    CKVC.isCk = YES;
                }
                [self.navigationController pushViewController:CKVC animated:YES];
            }
                break;
            case 2:
            {
                CommissonWithdrawalViewController *CWVC = [[CommissonWithdrawalViewController alloc]init];
                if ([self returnIsDealer]) {
                    CWVC.isFlag = NO;
                }else
                {
                    CWVC.isFlag = YES;
                }
                [self.navigationController pushViewController:CWVC  animated:YES];
            }
                break;
            case 3:
            {
                MyShopViewController *MSVC = [[MyShopViewController alloc]init];
                [self.navigationController pushViewController:MSVC animated:YES];
            }
                break;
             case 4:
            {
                ShopExpandViewController *SEVC = [[ShopExpandViewController alloc]init];
                [self.navigationController pushViewController:SEVC animated:YES];
            }
                break;
            case 5:
            {
                DealerSettingViewController *DSVC = [DealerSettingViewController new];
                [self.navigationController pushViewController:DSVC animated:YES];
            }
                break;
            case 6:
            {
                MyCodeViewController *MCVC = [MyCodeViewController new];
                MCVC.isShare = YES;
                [self.navigationController pushViewController:MCVC animated:YES];
            }
            default:
                break;
        }
    }
    if (indexPath.section == 3) {
        NSInteger i = indexPath.row;
        if ([self returnIsDealer]||[self returnIsAgent]) {
            i = indexPath.row +1;
        }
        switch (i) {
            case 0:
            {
                if(_islogin){
                    DealerApplyViewController* DAVC = [DealerApplyViewController new];
                    [self.navigationController pushViewController:DAVC animated:YES];
                }else
                {
                    [self loginAction:nil];
                }
            }
                break;
            case 1:
            {
                AboutUPJViewController *  aboutUPJVC =[AboutUPJViewController new];
                [self.navigationController pushViewController:aboutUPJVC animated:YES];
            }
                break;
            case 2:
            {
                if (_islogin) {
                    FeedBackViewController *fbVC = [FeedBackViewController new];
                    [self.navigationController pushViewController:fbVC animated:YES];
                }else
                {
                    [self loginAction:nil];
                }
            }
                break;
            case 3:
            {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"020-38989219"];
                UIWebView * callWebview = [[UIWebView alloc] init];
                callWebview.backgroundColor = [UIColor blueColor];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
                break;
            default:
                break;
        }
    }
}

-(void)loginAction:(UIButton *)button
{
    LoginViewController *lvc = [LoginViewController new];
    lvc.delegate = self;
    [self.navigationController pushViewController:lvc animated:YES];
}

-(void)btnAction:(UIButton*)btn
{
    if(_islogin)
    {
        OrderViewController *OVC = [OrderViewController new];
        OVC.number = btn.tag;
        OVC.mid = self.mid;
        [self.navigationController pushViewController:OVC animated:YES];
    }
    else
    {
        [self loginAction:nil];
    }
    
}

-(void)registerAction:(UIButton *)btn
{
    PhoneRegisteredViewController *phVC = [[PhoneRegisteredViewController alloc]init];
    phVC.number = 0;
    [self.navigationController pushViewController:phVC animated:YES];
}

-(void)loginFinishWithmodel:(MemberModel *)model
{
    
    [self setMidwithMid:model.mid];
    if (model.nickname.length != 0) {
        [self setNamewithNickName:model.nickname];
    }else
    {
        [self setNamewithNickName:@"0"];
    }
    if (model.realname.length != 0) {
        [self setNamewithRealName:model.realname];
    }else
    {
        [self setNamewithRealName:@"0"];
    }
    if (model.idcard.length != 0) {
        [self setIdCardwithIdCard:model.idcard];
    }else
    {
        [self setIdCardwithIdCard:@"0"];
    }
    if (model.mobile.length != 0) {
        [self setPhoneNumberwithPhoneNumber:model.mobile];
    }else
    {
        [self setPhoneNumberwithPhoneNumber:@"0"];
    }
    if(model.avatar.length != 0)
    {
        [self setImagewithImage:model.avatar];
        NSURL *url = [NSURL URLWithString:model.avatar];
        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        [self setImagedatawithImagedata:data];
    }else
    {
        [self setImagewithImage:@"0"];
    }
    if([model.member_agent_id isEqualToString:@"0"])
    {
        [self setIsAgentwithIsAgent:NO];
    }else
    {
        [self setIsAgentwithIsAgent:YES];
    }
    if ([model.domain_level isEqualToString:@"0"]) {
        [self setIsDealerwithIsDealer:NO];
    }else
    {
        [self setIsDealerwithIsDealer:YES];
    }
    if ([model.flag isEqualToString:@"0"]) {
        [self setIsFlagwithIsFlag:NO];
    }else
    {
        [self setIsFlagwithIsFlag:YES];
    }
    _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券"];
    if (self.islogin) {
        //先判断是创客还是经销商
        if([self returnIsDealer])
        {
            _arr2 = @[@"店铺二维码",@"我的分店",@"利润提现",@"我的店铺",@"蚁店推广",@"店铺设置",@"授权二维码"];
            _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
        }else if ([self returnIsFlag])
        {
            _arr2 = @[@"我的二维码",@"我的会员",@"佣金提现"];
            _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
        }else
        {
            _arr2 = @[];
            _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
        }
        if ([self returnIsAgent]) {
            _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券",@"代理商入口"];
            _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
        }
    }else
    {
        _arr2 = @[];
        _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
    }
    _memberView.frame = CGRectMake1(0, 160,414, 55*(_arr1.count+_arr2.count+_arr3.count)+150);
    _scrollView.contentSize = CGSizeMake(kWidth,_memberView.frame.origin.y+_memberView.frame.size.height+CGFloatMakeY(86));
    [_memberView reloadData];
    [self setIsLoginwithIsLogin:YES];
    [self postmid];
    [self postaddress];
    [self postcollect];
    [self postattention];
    [self postCoupon];
    [_headerView loginfinishwithimage:[self returnImage] name:[self returnNickName]];
    self.islogin = [self returnIsLogin];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)postmid
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:kInfo parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        _imageStr = responseObject[@"data"][@"avatar"];
        _domain_level = responseObject[@"data"][@"domain_level"];
        [self setOpenIdwithOpenId:responseObject[@"data"][@"wechat_openid"]];
        [self setNamewithNickName:responseObject[@"data"][@"nickname"]];
        if (_imageStr==nil || [_imageStr isKindOfClass:[NSNull class]]) {
            [_headerView.imageBtn setImage:[UIImage imageNamed:@"geren"] forState:UIControlStateNormal];
        }else
        {
            if (![_imageStr isEqualToString:[self returnImage]]) {
                NSURL *url = [NSURL URLWithString:_imageStr];
                [_headerView.imageBtn sd_setImageWithURL:url forState:UIControlStateNormal];
                [self setImagewithImage:_imageStr];
                NSData *data = [[NSData alloc]initWithContentsOfURL:url];
                [self setImagedatawithImagedata:data];
            }
            else
            {
                if ([self returnImageData].length == 0)
                {
                    NSURL *url = [[NSURL alloc]initWithString:_imageStr];
                    [_headerView.imageBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"geren"]];
                    [self setImagewithImage:_imageStr];
                    NSData *data1 = [[NSData alloc]initWithContentsOfURL:url];
                    [self setImagedatawithImagedata:data1];
                    
                }
                else
                {
                    [_headerView.imageBtn setImage:[UIImage imageWithData:[self returnImageData]] forState:UIControlStateNormal];
                }
            }
        }
        
        MemberModel *model = [MemberModel new];
        [model setValuesForKeysWithDictionary:responseObject[@"data"]];
        
        [self setMidwithMid:model.mid];
        if (model.nickname.length != 0) {
            [self setNamewithNickName:model.nickname];
        }else
        {
            [self setNamewithNickName:@"0"];
        }
        if (model.realname.length != 0) {
            [self setNamewithRealName:model.realname];
        }else
        {
            [self setNamewithRealName:@"0"];
        }
        if (model.idcard.length != 0) {
            [self setIdCardwithIdCard:model.idcard];
        }else
        {
            [self setIdCardwithIdCard:@"0"];
        }
        if (model.mobile.length != 0) {
            [self setPhoneNumberwithPhoneNumber:model.mobile];
        }else
        {
            [self setPhoneNumberwithPhoneNumber:@"0"];
        }
        if(model.avatar.length != 0)
        {
            [self setImagewithImage:model.avatar];
            NSURL *url = [NSURL URLWithString:model.avatar];
            NSData *data = [[NSData alloc]initWithContentsOfURL:url];
            [self setImagedatawithImagedata:data];
        }else
        {
            [self setImagewithImage:@"0"];
        }
        if([model.member_agent_id isEqualToString:@"0"])
        {
            [self setIsAgentwithIsAgent:NO];
        }else
        {
            [self setIsAgentwithIsAgent:YES];
        }
        if ([model.domain_level isEqualToString:@"0"]) {
            [self setIsDealerwithIsDealer:NO];
        }else
        {
            [self setIsDealerwithIsDealer:YES];
        }
        if ([model.flag isEqualToString:@"0"]) {
            [self setIsFlagwithIsFlag:NO];
        }else
        {
            [self setIsFlagwithIsFlag:YES];
        }
        _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券"];
        if (self.islogin) {
            //先判断是创客还是经销商
            if([self returnIsDealer])
            {
                _arr2 = @[@"店铺二维码",@"我的分店",@"利润提现",@"我的店铺",@"蚁店推广",@"店铺设置",@"授权二维码"];
                _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
            }else if ([self returnIsFlag])
            {
                _arr2 = @[@"我的二维码",@"我的会员",@"佣金提现"];
                _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
            }else
            {
                _arr2 = @[];
                _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
            }
            if ([self returnIsAgent]) {
                _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券",@"代理商入口"];
                _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
            }
        }else
        {
            _arr2 = @[];
            _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
        }
        _memberView.frame = CGRectMake1(0, 160,414, 55*(_arr1.count+_arr2.count+_arr3.count)+150);
        _scrollView.contentSize = CGSizeMake(kWidth,_memberView.frame.origin.y+_memberView.frame.size.height+CGFloatMakeY(86));
        [_memberView reloadData];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
      //[self postmid];
    }];
}

-(void)postaddress
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:kShow parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
        [self setAddresswithAddress:jsonArr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postaddress];
    }];
}

-(void)postcollect
{
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    NSDictionary * Ndic = [self md5DicWith:dic];
    [manager POST:kCollectList parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        NSString *errcode = [NSString stringWithFormat:@"%@",number];
        if ([errcode isEqualToString:@"0"]) {
            NSArray *jsonArr = @[];
            [self setCollectwithCollect:jsonArr];
        }else{
            NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
            [self setCollectwithCollect:jsonArr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postcollect];
    }];
}

-(void)postattention
{
    
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    
    NSDictionary *Ndic = [self md5DicWith:dic];
    
    [manager POST:kAllBrand parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        NSString *errcode2 = [NSString stringWithFormat:@"%@",number];
        if ([errcode2 isEqualToString:@"10235"]) {
            NSArray *jsonArr = [NSArray new];
            [self setAttentionwithAttention:jsonArr];
        }else{
            NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
            [self setAttentionwithAttention:jsonArr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postattention];
    }];
}

-(void)postCoupon
{
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
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    NSDictionary * Ndic = [self md5DicWith:dic];
    //发送请求
    [manager POST:kCoupon parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *jsonArr1 = [NSArray arrayWithArray:responseObject];
        NSMutableArray *setArr = [NSMutableArray new];
        for (NSDictionary *dic in jsonArr1) {
            if ([dic[@"status"] isEqualToString:@"1"]) {
                [setArr addObject:dic];
            }
        }
        NSArray *settingArr = [NSArray arrayWithArray:setArr];
        [self setConponwithConpon:settingArr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
        [self postCoupon];
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"个人中心";
    
    self.isShowTab = NO;
    [self showTabBarWithTabState:self.isShowTab];
    self.navigationController.navigationBar.translucent = NO;
    self.mid = [self returnMid];
    self.islogin = [self returnIsLogin];
    _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券"];
    if (self.islogin) {
        //先判断是创客还是经销商
        if([self returnIsDealer])
        {
            _arr2 = @[@"店铺二维码",@"我的分店",@"利润提现",@"我的店铺",@"蚁店推广",@"店铺设置",@"授权二维码"];
            _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
        }else if ([self returnIsFlag])
        {
            _arr2 = @[@"我的二维码",@"我的会员",@"佣金提现"];
            _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
        }else
        {
            _arr2 = @[];
            _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
        }
        if ([self returnIsAgent]) {
            _arr1 = @[@"我的收藏",@"我关注的品牌",@"收货地址",@"我的优惠券",@"代理商入口"];
            _arr3 = @[@"关于友品集",@"意见反馈",@"联系我们"];
        }
    }else
    {
        _arr2 = @[];
        _arr3 = @[@"开店申请",@"关于友品集",@"意见反馈",@"联系我们"];
    }
    _memberView.frame = CGRectMake1(0, 160,414, 55*(_arr1.count+_arr2.count+_arr3.count)+150);
    _scrollView.contentSize = CGSizeMake(kWidth,_memberView.frame.origin.y+_memberView.frame.size.height+CGFloatMakeY(86));
    [_memberView reloadData];
    [_headerView islogin:[self returnIsLogin]];
    [_headerView update:[self returnNickName]];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

//设置页面
-(void)settingAction:(UIButton *)btn
{
    SettingViewController *setVC = [SettingViewController new];
    setVC.delegate = self;
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)midlogout
{
    [_headerView logoutfinish];
}

// 修改头像
- (void)changeHeaderImg{
    if ([self returnIsLogin]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAct = [UIAlertAction actionWithTitle:@"拍照获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *thumbAct = [UIAlertAction actionWithTitle:@"相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:takePhotoAct];
        [alertController addAction:thumbAct];
        [alertController addAction:cancelAct];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img1 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *img = [self scaleImage:img1 toScale:0.3];
    
    NSData *data = UIImagePNGRepresentation(img);
    [self setImagedatawithImagedata:data];
    
    NSString *base64Img = [self image2DataURL:img];
    // 上传头像
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"avatar":base64Img};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //传入的参数
    
    //发送请求
    [manager POST:kUpdateHeader parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        UIAlertController *sucAl = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"errmsg"] preferredStyle:UIAlertControllerStyleAlert];
        [self.navigationController presentViewController:sucAl animated:YES completion:^{
            sleep(1);
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [_headerView.imageBtn setImage:img forState:UIControlStateNormal];
                [self setImagewithImage:responseObject[@"data"]];
            }];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 头像转化base64格式
- (BOOL) imageHasAlpha: (UIImage *) image{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *) image2DataURL: (UIImage *) image{
    
    NSData *imageData = nil;
    NSString *mimeType = nil;
    if ([self imageHasAlpha: image])
    {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    }
    else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scaleSize,image.size.height*scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
