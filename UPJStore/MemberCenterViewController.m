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
#import "AppDelegate.h"
#import "MemberModel.h"
#import "UIViewController+CG.h"
#import "SettingViewController.h"
#import "AFNetworking.h"
#import "CouponModel.h"
#import "CKListViewController.h"
#import "UIImageView+WebCache.h"

#define widthSize 414.0/320
#define hightSize 736.0/568
@interface MemberCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LoginAciton,PerinfViewPush,login,logout,sendModel,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView * memberView;
@property (nonatomic,strong) NSArray *arr;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HeaderView * headerView;
@property (nonatomic,strong) NSString *imageStr;

@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.delegate = self;
    
    self.mid = [self returnMid];
    self.islogin = [self returnIsLogin];
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    self.view.backgroundColor = backcolor;
    UIColor *headercolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    
    
    _headerView = [[HeaderView alloc]initWithFrame:CGRectMake1(0, -20*widthSize, 414, 144*widthSize) withIsLogin:self.islogin withname:[self returnNickName]];
    _headerView.backgroundColor = headercolor;
    _headerView.delegate = self;
    _headerView.imageView.userInteractionEnabled = YES;
    if ([self returnIsLogin]) {
        [self postmid];
    }
    // 添加手势设置头像
    UITapGestureRecognizer *singleRecongnizer;
    singleRecongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeaderImg:)];
    singleRecongnizer.numberOfTapsRequired = 1;
    [_headerView.imageView addGestureRecognizer:singleRecongnizer];
    PerInfView * perinfView = [[PerInfView alloc]initWithFrame:CGRectMake1(0, 124*widthSize, k6PWidth, 52*widthSize)];
    perinfView.delegate =self;
    
    _arr = @[@"收货地址",@"我的优惠券",@"关于友品集",@"意见反馈",@"客服热线",@"我的会员"];
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [self.scrollView addSubview:_headerView];
    
    
    _memberView = [[UITableView alloc]initWithFrame:CGRectMake(0, 176*hightSize*app.autoSizeScaleY, self.view.bounds.size.width, 88*_arr.count) style:UITableViewStylePlain];
    _memberView.delegate =self;
    _memberView.dataSource = self;
    _memberView.backgroundColor = backcolor;
    [_memberView registerClass:[MemberTableViewCell class] forCellReuseIdentifier:@"memberCell"];
    _memberView.scrollEnabled = NO;
    
    [self.scrollView addSubview:_memberView];
    [self.scrollView addSubview:perinfView];
    
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width,_headerView.frame.size.height+perinfView.frame.size.height+_memberView.frame.size.height-56*hightSize+30);
    _scrollView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view.
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }
    else
        return _arr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *Identifier = @"memberCell";
    MemberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[MemberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    if (indexPath.section==0) {
        cell.titleLabel.text = @"我的订单";
        cell.iconView.image = [UIImage imageNamed:@"MyOrder"];
        cell.iconView.contentMode = UIViewContentModeScaleAspectFit;
        cell.arrowView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else{
        cell.titleLabel.text = _arr[indexPath.row];
        
        cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Member%ld",indexPath.row]];
        
        //ImageView 自适应。
        cell.iconView.contentMode = UIViewContentModeScaleAspectFit;
        cell.arrowView.contentMode = UIViewContentModeScaleAspectFit;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(55);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma 2016年04月08日15:59:16 修改 图片路径 修改iconView大小
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"待付款",@"待发货",@"待收货",@"待评价"];
        for (int i = 0; i <4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 50, k6PWidth/4, 10)];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = arr[i];
            
            btn.frame = CGRectMake1(k6PWidth/4*i, 0, k6PWidth/4, 50);
            btn.tag = i+1;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 10, 33, 33)];
            iconView.center = CGPointMake(btn.frame.size.width/2, btn.frame.size.height/2);
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            
            iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dingdan%d",i]];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 70, 414, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
            [view addSubview:lineView];
            [btn addSubview:iconView];
            [view addSubview:btn];
            [btn addSubview:label];
            
        }
        return view;
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section  == 0) {
        return CGFloatMakeY(65);
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, k6PWidth, 16)];
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    view.backgroundColor = backcolor;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        AboutUPJViewController *  aboutUPJVC =[AboutUPJViewController new];
        [self.navigationController pushViewController:aboutUPJVC animated:YES];
    }else
        if (indexPath.row == 4)
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"020-38989219"];
            UIWebView * callWebview = [[UIWebView alloc] init];
            callWebview.backgroundColor = [UIColor blueColor];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }else
            if (_islogin)
            {
                if(indexPath.section == 0)
                {
                    OrderViewController *OVC = [OrderViewController new];
                    OVC.number = 0;
                    OVC.mid = self.mid;
                    [self.navigationController pushViewController:OVC animated:YES];
                }
                else
                {
                    if (indexPath.row == 0)
                    {
                        MyAddressViewController *myaddressVC = [MyAddressViewController new];
                        [self.navigationController pushViewController:myaddressVC animated:YES];
                    }
                    if (indexPath.row == 1)
                    {
                        MyCouponViewController *mycouponVC = [MyCouponViewController new];
                        mycouponVC.mid = self.mid;
                        [self.navigationController pushViewController:mycouponVC animated:YES];
                    }
                    if (indexPath.row == 3) {
                        FeedBackViewController *fbVC = [FeedBackViewController new];
                        [self.navigationController pushViewController:fbVC animated:YES];
                    }
                    if (indexPath.row == 5) {
                        CKListViewController * ckListVC = [[CKListViewController alloc]init];
                        
                        [self.navigationController pushViewController:ckListVC animated:YES];
                    }
                }
            }
            else
            {
                [self loginAction:nil];
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

-(void)perinfViewPush:(NSInteger)number
{
    if (_islogin) {
        switch (number) {
            case 0:
            {
                MyCookieViewController *MCVC = [MyCookieViewController new];
                [self.navigationController pushViewController:MCVC animated:YES];
            }
                break;
            case 1:
            {
                MyCollectViewController *MCVC = [MyCollectViewController new];
                MCVC.mid = self.mid;
                [self.navigationController pushViewController:MCVC animated:YES];
            }
                break;
            case 2:
            {
                MyAttentionViewController *MAVC = [MyAttentionViewController new];
                [self.navigationController pushViewController:MAVC animated:YES];
            }
                break;
            default:
                break;
        }
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
    }else
    {
        [self setImagewithImage:@"0"];
    }
    [self setIsLoginwithIsLogin:YES];
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:kInfo parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _imageStr = responseObject[@"data"][@"avatar"];
        [self setNamewithNickName:responseObject[@"data"][@"nickname"]];
        if (_imageStr==nil || [_imageStr isKindOfClass:[NSNull class]]) {
            _headerView.imageView.image = [UIImage imageNamed:@"geren"];
        }else
        {
            if (![_imageStr isEqualToString:[self returnImage]]) {
                NSURL *url = [NSURL URLWithString:_imageStr];
                [_headerView.imageView sd_setImageWithURL:url];
                [self setImagewithImage:_imageStr];
                NSData *data = [[NSData alloc]initWithContentsOfURL:url];
                [self setImagedatawithImagedata:data];
            }
            else
            {
                if ([self returnImageData].length == 0)
                {
                    NSURL *url = [[NSURL alloc]initWithString:_imageStr];
                    [_headerView.imageView sd_setImageWithURL:url];
                    NSData *data1 = [[NSData alloc]initWithContentsOfURL:url];
                    [self setImagedatawithImagedata:data1];
                    
                }
                else
                {
                    _headerView.imageView.image = [UIImage imageWithData:[self returnImageData]];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)postaddress
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:kShow parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *jsonArr = [NSArray arrayWithArray:responseObject];
        [self setAddresswithAddress:jsonArr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)postcollect
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
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
    }];
}

-(void)postattention
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
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
    }];
}

-(void)postCoupon
{
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
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.mid = [self returnMid];
    self.islogin = [self returnIsLogin];
    [_headerView islogin:[self returnIsLogin]];
    [_headerView update:[self returnNickName]];
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
- (void)changeHeaderImg:(UITapGestureRecognizer *)recognizer{
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //传入的参数
    
    //发送请求
    [manager POST:kUpdateHeader parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        UIAlertController *sucAl = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"errmsg"] preferredStyle:UIAlertControllerStyleAlert];
        [self.navigationController presentViewController:sucAl animated:YES completion:^{
            sleep(1);
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                _headerView.imageView.image = img;
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
