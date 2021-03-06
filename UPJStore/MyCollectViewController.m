//
//  MyCollectViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/11.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyCollectViewController.h"
#import "CollectModel.h"
#import "UIViewController+CG.h"
#import "CollectTableViewCell.h"
#import "GoodSDetailViewController.h"

@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *jsonArr;
    NSArray *dataArr;
    UIImageView *imageView;
    UILabel *label;
    UITableView *BackTableView;
}
@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
 //   UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
 //   UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
      UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
  //  UIColor *bordercolor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    
    self.navigationItem.title = @"收藏的商品";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = backcolor;
    
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MyCollecticon"]];
    imageView.frame = CGRectMake1(152, 105, 105, 105);
    [self.view addSubview:imageView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 210, 414, 40)];
    label.text = @"暂无收藏的商品";
    label.textAlignment = 1;
    label.textColor = textcolor;
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    [self.view addSubview:label];
    
    BackTableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0, 414, 672)];
    BackTableView.delegate = self;
    BackTableView.dataSource = self;
    BackTableView.showsVerticalScrollIndicator = NO;
    BackTableView.backgroundColor = backcolor;
    [BackTableView registerClass:[CollectTableViewCell class] forCellReuseIdentifier:@"collect"];
    BackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:BackTableView];
    [self setMBHUD];
    [self postcollect];
 //   [self modelGet];
}

-(void)modelGet
{
    jsonArr = [self returnCollect];
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSDictionary *dic in jsonArr) {
        CollectModel *model = [CollectModel new];
        [model setValuesForKeysWithDictionary:dic];
        [tempArr addObject:model];
    }
    dataArr = [NSArray arrayWithArray:tempArr];
    if (dataArr.count == 0) {
        BackTableView.hidden = YES;
        imageView.hidden = NO;
        label.hidden = NO;
    }
    else
    {
        BackTableView.hidden = NO;
        imageView.hidden = YES;
        label.hidden = YES;
        [BackTableView reloadData];
    }
    [self.loadingHud hideAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collect"];
    CollectModel *model = dataArr[indexPath.row];
    cell.titlelabel.text = model.title;
    cell.pricelabel.text = [NSString stringWithFormat:@" ¥%@",model.marketprice];
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(110);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectModel *model = dataArr[indexPath.row];
    
    GoodSDetailViewController * goodDetailVC = [[GoodSDetailViewController alloc]init];
    goodDetailVC.goodsDic = @{@"id":model.aid,@"appkey":APPkey};
    self.navigationItem.title = @"";
    goodDetailVC.isFromCollection = YES;
    [self.navigationController pushViewController:goodDetailVC animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"收藏的商品";
    self.navigationController.navigationBarHidden = NO;
    self.isShowTab = YES;
    [self hideTabBarWithTabState:self.isShowTab];
    self.navigationController.navigationBar.translucent = NO;
    [self postcollect];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

-(void)pop
{
    [self postcollect];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)postcollect
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
    #pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    [manager POST:kCollectList parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
     //   NSLog(@"%@",task);
        NSNumber *number = [responseObject valueForKey:@"errcode"];
        NSString *errcode = [NSString stringWithFormat:@"%@",number];
        if ([errcode isEqualToString:@"0"]) {
            NSArray *jsonArr2 = @[];
            [self setCollectwithCollect:jsonArr2];
        }else{
            NSArray *jsonArr2 = [NSArray arrayWithArray:responseObject];
            [self setCollectwithCollect:jsonArr2];
        }
        [self modelGet];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
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
