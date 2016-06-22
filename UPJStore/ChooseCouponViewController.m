//
//  ChooseCouponViewController.m
//  UPJStore
//
//  Created by upj on 16/5/6.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ChooseCouponViewController.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"
#import "BookIngViewController.h"
#import "CouponTableViewCell.h"
#import "CouponModel.h"
#import "AFNetWorking.h"

@interface ChooseCouponViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITextField * Couponfield;
@property (nonatomic,strong) UITableView * CouponTableView;
@property (nonatomic,strong) NSMutableArray * couponList;

@end

@implementation ChooseCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * BackGroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    BackGroundView.image = [UIImage imageNamed:@"couponBackGround"];
    [self.view addSubview:BackGroundView];
    
    UIImageView * borderView =[[UIImageView alloc]initWithFrame:CGRectMake1(40, 20, 414-80, 736-120)];
    borderView.image = [UIImage imageNamed:@"borderView"];
    [self.view addSubview:borderView];
    
    _Couponfield = [[UITextField alloc]initWithFrame:CGRectMake1(55, 140, 414-80-30, 40)];
    _Couponfield.layer.borderWidth = 1;
    _Couponfield.delegate =self;
    _Couponfield.layer.borderColor =[[UIColor colorFromHexRGB:@"e54b3d"]CGColor];
    _Couponfield.layer.cornerRadius = 10;
    _Couponfield.placeholder = @"\t请输入兑换码";
    [_Couponfield setValue:[UIColor colorFromHexRGB:@"e54b3d"] forKeyPath:@"_placeholderLabel.textColor"];


    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake1(55, 580, 414-80-30, 40);
    [sureBtn setTitle:@"确认使用优惠" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor colorFromHexRGB:@"e54b3d"];
    [sureBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 10;
    sureBtn.clipsToBounds = YES;
    [self.view addSubview:sureBtn];
    
    [self postData];
    [self.view addSubview:_Couponfield];
    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _couponList.count;
}

-(void)postData
{
     #pragma dic MD5
        NSDictionary * Ndic = [self md5DicWith:_dic];
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        
        [manager POST:kCouponList parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            DLog(@"%@",responseObject);
            NSDictionary * ddic = responseObject;
            
            if (ddic.count != 2) {
                CouponModel * model = [[CouponModel alloc]init];
                NSArray * arr = ddic[@"coupon"];
                for (NSDictionary * dic in arr)
                {
                    [model setValuesForKeysWithDictionary:dic];
                    model.couponID = dic[@"id"];
                    [self.couponList addObject:model];
                }
                [self.CouponTableView reloadData];
   
            }else
            {
                
            }
            
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            DLog(@"error : %@",error);
            
        }];
        
    
}


-(UITableView *)CouponTableView
{
    if (!_CouponTableView) {
        _CouponTableView = [[UITableView alloc]initWithFrame:CGRectMake1(55, 290, 414-80-30, 280) style:UITableViewStylePlain];
        _CouponTableView.backgroundColor = [UIColor clearColor];
        _CouponTableView.dataSource =self;
        _CouponTableView.delegate = self;
        [self.view addSubview:_CouponTableView];
    }
    return _CouponTableView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"amount":_dic[@"amount"],@"couponid":[_couponList[indexPath.row] couponID]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    DLog(@"Ndic = %@",Ndic);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager POST:kDoCoupon parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        NSDictionary * dic =@{@"couponid":[_couponList[indexPath.row] couponID],@"reduce":responseObject[@"reduce"],@"title":[_couponList[indexPath.row] title],@"coupon_code":@"0"};
        NSNotification *notification =[NSNotification notificationWithName:@"reduce" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        [self pop];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error : %@",error);
        
    }];
    
    
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponTableViewCell *cell = [[CouponTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"coupon" FromCoupon:YES];

    CouponModel *model = _couponList[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
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
    return CGFloatMakeY(90);
}

-(void)BtnAction:(UIButton *)btn
{
    NSDictionary * dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"amount":_dic[@"amount"],@"coupon_number":_Couponfield.text};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    DLog(@"Ndic = %@",Ndic);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager POST:kCouponNumber parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        NSDictionary * dic = responseObject;
               NSString * stateStr = dic[@"message"];
    
        UIAlertController * aVC = [UIAlertController alertControllerWithTitle:@"优惠券使用情况" message:stateStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action;
        
        if ([[NSString stringWithFormat:@"%@",dic[@"code"]]isEqualToString:@"0"])
        {
            action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSDictionary * CouponDic = @{@"appkey":APPkey,@"mid":[self returnMid],@"amount":_dic[@"amount"],@"coupon_code":dic[@"coupon_code"]};
                
                NSDictionary * Ndic = [self md5DicWith:CouponDic];
                DLog(@"Ndic = %@",Ndic);
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
                
                [manager POST:kDoCoupon parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    DLog(@"%@",responseObject);
                    NSDictionary * CodeDic =@{@"coupon_code":dic[@"coupon_code"],@"reduce":responseObject[@"reduce"],@"title":dic[@"title"],@"couponid":@"0"};
                    NSNotification *notification =[NSNotification notificationWithName:@"reduce" object:nil userInfo:CodeDic];
                    [[NSNotificationCenter defaultCenter]postNotification:notification];
                    [self pop];

                    
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }];

        }else
        {
            action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        }

        [aVC addAction:action];
        
        [self.navigationController presentViewController:aVC animated:YES completion:^{
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error : %@",error);
        
    }];
}




-(void)pop
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSMutableArray *)couponList
{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_Couponfield resignFirstResponder];
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
