//
//  SettingViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/4/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+CG.h"
#import "AFNetWorking.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "ModifyViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arr;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
  //  UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    self.view.backgroundColor = backcolor;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"设置";
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent =NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui_@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    
    arr = @[@"注销当前用户",@"解绑微信账号",@"修改个人资料",@"清理缓存"];
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0, 414, 672)style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = backcolor;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setting"];
 //   tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"setting"];
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
 //   UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 59.5, 414, 0.5)];
 //   lineView.backgroundColor = [UIColor grayColor];
 //   [cell addSubview:lineView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self logoutAction];
            break;
        case 1:
            [self unbindAction];
            break;
        case 2:
        {
            [self modifyAction];
        }
            break;
        case 3:
            [self clearAction];
            break;
        default:
            break;
    }
}

-(void)clearAction
{
    // 计算缓存 字节
    float size =  [[SDImageCache sharedImageCache]getSize];
    NSString *sizeStr = [NSString stringWithFormat:@"缓存大小：%.1fM",size/1024/1024];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清理缓存" message:sizeStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 清理缓存
        [[SDImageCache sharedImageCache] clearDisk];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:clearAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)logoutAction
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"是否注销当前用户" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setMidwithMid:@"0"];
        [self setIsLoginwithIsLogin:NO];
        [self.delegate midlogout];
        [self pop];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCon addAction:okAction];
    [alertCon addAction:cancelAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}
-(void)unbindAction{
    if (![self returnIsLogin]) {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
        
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定解绑微信账号？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //传入的参数
            NSDictionary *dic = @{@"mid":[self returnMid],@"type":@"wechat",@"appkey":APPkey};
#pragma dic MD5
            NSDictionary * Ndic = [self md5DicWith:dic];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            
            //发送请求
            [manager POST:kUnbind parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DLog(@"%@",responseObject);
                NSString *str1 = [responseObject valueForKey:@"errmsg"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DLog(@"failure%@",error);
            }];
        }];
        [alertC addAction:sureAct];
        [alertC addAction:cancelAct];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    

}
-(void)pop
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)modifyAction
{
    if (![self returnIsLogin])
    {
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        LoginVC.isFromDetail = YES;
        [self.navigationController pushViewController:LoginVC animated:YES];
    }else{
        ModifyViewController *MOVC = [[ModifyViewController alloc]init];
        [self.navigationController pushViewController:MOVC animated:YES];
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
