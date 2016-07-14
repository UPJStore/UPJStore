
//
//  MyCouponViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/14.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyCouponViewController.h"
#import "AFNetworking.h"
#import "CouponModel.h"
#import "UIViewController+CG.h"
#import "CouponTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIColor+HexRGB.h"

@interface MyCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *line4;
    UIView *line3;
    UILabel *label1;
    UIImageView *imageView;
    UIView *couponView;
    NSArray *jsonArr;
    NSArray *dataArr;
    NSArray *usedArr;
    UITableView *couponTableView;
    BOOL isUsed;
    UIAlertController *alertCon;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];//666
    //  UIColor *bordercolor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];//333
    
    self.navigationItem.title = @"我的优惠券";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
       self.view.backgroundColor = [UIColor whiteColor];
    
    isUsed = NO;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 414, 1)];
    line1.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
    [self.view addSubview:line1];
    
    UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBtn.frame = CGRectMake1(26, 10, 362, 50);
    [exchangeBtn setTitle:@"兑换优惠券" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exchangeBtn.backgroundColor = btncolor;
    [exchangeBtn.layer setCornerRadius:5.0];
    exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [exchangeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeBtn];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 70, 414, 1)];
    line2.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
    [self.view addSubview:line2];
    
    NSArray *arr = @[@"可使用",@"已使用"];
    
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:textcolor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        button.titleLabel.textAlignment =1;
        button.tag = i;
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake1(0+207*i, 80, 207, 40);
        [self.view addSubview:button];
    }
    
    line3 = [[UIView alloc]initWithFrame:CGRectMake1(0, 120, 414, 1)];
    line3.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
    [self.view addSubview:line3];
    
    line4 = [[UIView alloc]initWithFrame:CGRectMake1(79, 119, 48, 2)];
    line4.backgroundColor = btncolor;
    [self.view addSubview:line4];
    
    couponView = [[UIView alloc]initWithFrame:CGRectMake1(0, 123, 414, 549)];
    [self.view addSubview:couponView];
    
    UIImage *image = [UIImage imageNamed:@"MyCouponicon"];
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake1(152, 40, 110, 110);
    [couponView addSubview:imageView];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake1(0, 170, 414, 12)];
    label1.text = @"没有可使用的优惠券";
    label1.textColor = textcolor;
    label1.textAlignment = 1;
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [couponView addSubview:label1];
    
    couponTableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 121, 414, 549)];
    couponTableView.delegate = self;
    couponTableView.dataSource = self;
    couponTableView.backgroundColor = [UIColor whiteColor];
    couponTableView.showsVerticalScrollIndicator = NO;
    [couponTableView registerClass:[CouponTableViewCell class] forCellReuseIdentifier:@"coupon"];
    couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:couponTableView];
    [self setMBHUD];
    [self postCoupon];
}

-(void)modelGet
{
    NSMutableArray *tempArr = [NSMutableArray new];
    NSMutableArray *tempArr2 = [NSMutableArray new];
    for (NSDictionary *dic in jsonArr) {
        CouponModel *model = [CouponModel new];
        [model setValuesForKeysWithDictionary:dic];
        if ([model.status isEqualToString:@"1"]) {
            [tempArr addObject:model];
        }
        else
        {
            [tempArr2 addObject:model];
        }
    }
    dataArr = [NSArray arrayWithArray:tempArr];
    usedArr = [NSArray arrayWithArray:tempArr2];
    if (!isUsed) {
        if (dataArr.count != 0) {
            couponView.hidden = YES;
            couponTableView.hidden = NO;
            [couponTableView reloadData];
        }else
        {
            couponTableView.hidden = YES;
            couponView.hidden = NO;
        }
    }
    else
    {
        if (usedArr.count != 0) {
            couponView.hidden = YES;
            couponTableView.hidden = NO;
            [couponTableView reloadData];
        }else
        {
            couponTableView.hidden = YES;
            couponView.hidden = NO;
        }
    }
    [_loadingHud hideAnimated:YES];
    _loadingHud = nil;
}

-(void)tapAction:(UIButton*)button
{
    [self setMBHUD];
    [UIView animateWithDuration:0.5 animations:^{
        line4.frame = CGRectMake1(79+207*button.tag, 119, 48, 2);
        switch (button.tag) {
            case 0:
            {
                label1.text = @"没有可使用的优惠券";
                isUsed = NO;
                [self postCoupon];
            }
                break;
            case 1:
            {
                label1.text = @"没有已使用的优惠券";
                isUsed = YES;
                [self postCoupon];
            }
                break;
            default:
                break;
        }
    }];
}

-(void)changeAction:(UIButton*)btn
{
    //暂时没有兑换优惠券
    alertCon = [UIAlertController alertControllerWithTitle:nil message:@"没有可兑换的优惠券" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertCon addAction:okAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}

-(void)postCoupon
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    
    
    NSDictionary *Ndic = [self md5DicWith:dic ];
    //发送请求
    [manager POST:kCoupon parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        jsonArr = [NSArray arrayWithArray:responseObject];
        NSMutableArray *setArr = [NSMutableArray new];
        for (NSDictionary *dic in jsonArr) {
            if ([dic[@"status"] isEqualToString:@"1"]) {
                [setArr addObject:dic];
            }
        }
        NSArray *settingArr = [NSArray arrayWithArray:setArr];
        [self setConponwithConpon:settingArr];
        [self modelGet];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!isUsed) {
        return [dataArr count];
    }else
    {
        return [usedArr count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell *cell = [[CouponTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"coupon"];
    CouponModel *model ;
    if (!isUsed) {
        model = dataArr[indexPath.row];
    }else
    {
        model = usedArr[indexPath.row];
    }
    cell.label1.text = model.title;
    cell.timeLabel.text = [NSString stringWithFormat:@"有效时间至%@",[self timeWithcuo:model.endtime]];
    cell.contentLabel.text = model.content;
    NSString *str = [NSString stringWithFormat:@"%.0f",model.denomination.floatValue];
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@",str];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(100);
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 加载动画
-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:couponTableView animated:YES];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

-(NSString *)timeWithcuo:(NSString*)cuo
{
    NSTimeInterval time=[cuo doubleValue];
    //+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate: detaildate];
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
