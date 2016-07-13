//
//  MyAttentionViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/11.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "UIViewController+CG.h"
#import "AttentionModel.h"
#import "AttentionTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "brandViewController.h"

@interface MyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,AttentionCancelAction>
{
    NSArray *jsonArr;
    NSArray *dataArr;
    UIImageView *imageView;
    UILabel *label;
    UITableView *tableView;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;
@end

@implementation MyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
//    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
 //   UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
      UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
   // UIColor *bordercolor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    
    self.navigationItem.title = @"我关注的品牌";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = backcolor;
    
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MyCollecticon"]];
    imageView.frame = CGRectMake1(152, 105, 105, 105);
    [self.view addSubview:imageView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 210, 414, 40)];
    label.text = @"暂无关注的品牌";
    label.textAlignment = 1;
    label.textColor = textcolor;
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [self.view addSubview:label];
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0, 414, 736)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = backcolor;
    [tableView registerClass:[AttentionTableViewCell class] forCellReuseIdentifier:@"attention"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [self setMBHUD];
    [self postattention];
}

-(void)modelGet
{
    jsonArr = [self returnAttention];
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSDictionary *dic in jsonArr) {
        AttentionModel *model = [AttentionModel new];
        [model setValuesForKeysWithDictionary:dic];
        [tempArr addObject:model];
    }
    dataArr = [NSArray arrayWithArray:tempArr];
    
    
    
    if (dataArr.count == 0) {
        tableView.hidden = YES;
        imageView.hidden = NO;
        label.hidden = NO;
    }
    else
    {
        tableView.hidden = NO;
        imageView.hidden = YES;
        label.hidden = YES;
        [tableView reloadData];
    }
    [_loadingHud hideAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionTableViewCell *cell = [[AttentionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"collect"];
    AttentionModel *model = dataArr[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.pid = model.pid;
    cell.delegate = self;
    cell.mid = [self returnMid];
    [cell getImageViewWithstr:[@"http://www.upinkji.com/resource/attachment/" stringByAppendingString:model.thumb]];
    cell.pictureView.contentMode = UIViewContentModeScaleAspectFit;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(140);
}

-(void)AttentionCancelWithdic:(NSDictionary *)dic
{
    [self setMBHUD];

    [self postattentionWithdic:dic];
}

-(void)postattentionWithdic:(NSDictionary*)dic
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
    [manager POST:kSAttenTionBrandUrl parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSString *str1 = [responseObject valueForKey:@"errmsg"];
        UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self postattention];
        }];
        [alertCon addAction:okAction];
    
        [self presentViewController:alertCon animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)pop
{
    [self postattention];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    self.navigationController.navigationBar.translucent = NO;
    [self postattention];
}

-(void)postattention
{
    //发送请求
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
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
  
 
    [manager POST:kAllBrand parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        NSString *errcode2 = [NSString stringWithFormat:@"%@",number];
        if ([errcode2 isEqualToString:@"10235"]) {
            NSArray *jsonArr1 = [NSArray new];
            [self setAttentionwithAttention:jsonArr1];
        }else{
            NSArray *jsonArr1 = [NSArray arrayWithArray:responseObject];
            [self setAttentionwithAttention:jsonArr1];
        }
        [self modelGet];
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DLog(@"failure%@",error);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    brandViewController * brandVC = [[brandViewController alloc]init];
    AttentionModel *model =dataArr[indexPath.row];
    brandVC.dic = @{@"appkey":APPkey,@"pid":model.cid,@"cid":model.pid};
    brandVC.navigationItem.title = model.title;
    
    [self.navigationController pushViewController:brandVC animated:YES];
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
