//
//  CKListViewController.m
//  UPJStore
//
//  Created by upj on 16/5/24.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CKListViewController.h"
#import "UIColor+HexRGB.h"
#import "UIViewController+CG.h"
#import "MJRefresh.h"
#import "AFNetWorking.h"
#import "UIImageView+WebCache.h"
#import "CKModel.h"
#import "CKTableViewCell.h"

@interface CKListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,strong) UIView * LevelView ;

@property (nonatomic,strong) NSMutableArray *Level1Arr;
@property (nonatomic,strong) NSMutableArray *Level2Arr;

@property (nonatomic,strong) NSMutableArray *tableArr;
@property (nonatomic,assign) NSInteger pageCount;

@property (nonatomic,strong) NSString *Level1Str;
@property (nonatomic,strong) NSString *Level2Str;

@end

@implementation CKListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden =YES;
    self.navigationItem.title = @"我的会员";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    _LevelView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0,k6PWidth , 40)];
    _LevelView.layer.borderWidth = 0.5;
    _LevelView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _LevelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_LevelView];
    for (int i = 0; i<2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*kWidth/2, 0, kWidth/2, CGFloatMakeY(40));
        
        btn.tag = i+1;
        NSString * sectionStr ;
        if (i==0) {
            sectionStr = @"一级";
            [btn setBackgroundColor:[UIColor colorFromHexRGB:@"cc2245"]];
            btn.selected = YES;
        }else
        {
            sectionStr = @"二级";
        }
        [btn setTitle:[NSString stringWithFormat:@"%@会员（0）",sectionStr] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_LevelView addSubview:btn];
        
        }
    _pageCount = 1;
    
    [self MJHeader];
    // Do any additional setup after loading the view.

}

-(void)reloadData:(UIButton *)btn
{
    for (UIButton *btn in _LevelView.subviews) {
        [btn setBackgroundColor:[UIColor whiteColor]];

        btn.selected = NO;
    }
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorFromHexRGB:@"cc2245"]];
    
    if (btn.tag == 1 ) {
        self.tableArr = _Level1Arr;
    }else
        self.tableArr = _Level2Arr;
    
    [_tableview reloadData];

}

-(void)postTokenWithPage:(NSInteger)page
{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    NSDictionary * dic =@{@"member_id":[self returnMid],@"appkey":APPkey,@"page":[NSString stringWithFormat:@"%ld",(long)page]};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    [manager POST:kCKList parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        
        NSDictionary * dic = responseObject;
        
        _Level1Str = [NSString stringWithFormat:@"%@",dic[@"count1"]];
        _Level2Str = [NSString stringWithFormat:@"%@",dic[@"count2"]];
        
        [(UIButton *)[_LevelView viewWithTag:1] setTitle:[NSString stringWithFormat:@"一级会员（%@）",_Level1Str] forState:UIControlStateNormal];
        
        if (![_Level2Str isEqualToString:@"0"]) {
             [(UIButton *)[_LevelView viewWithTag:2] setTitle:[NSString stringWithFormat:@"二级会员（%@）",_Level2Str] forState:UIControlStateNormal];
        }

        
        NSMutableArray * arr1 = dic[@"fansall"];
        NSMutableArray * arr2 = dic[@"fansall2"];
        
        for (NSDictionary *dic  in arr1) {
            CKModel *model = [[CKModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            if(model.nickname.length == 0)
            {
                model.nickname = @" ";
            }
            [self.Level1Arr addObject:model];
        }
        for (NSDictionary * dic in arr2) {
            CKModel * model = [[CKModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            if(model.nickname.length == 0)
            {
                model.nickname = @" ";
            }
            if (model.tui.length == 0) {
                model.tui = @" ";
            }
            [self.Level2Arr addObject:model];
        }
        if ([(UIButton *)[_LevelView viewWithTag:1] isSelected]==YES) {
            self.tableArr = _Level1Arr;
        }
        else
        {
            self.tableArr = _Level2Arr;
        }
        
        [_tableview reloadData];
        _pageCount ++;
        
        [self MJFooter];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"errer %@",error);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];

    }];
    

    
    
}

#pragma mark UITableView + 下拉刷新 默认
- (void)MJHeader
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableArr removeAllObjects];
        [_Level1Arr removeAllObjects];
        [_Level2Arr removeAllObjects];
        [weakSelf postTokenWithPage:1];
    }];
    
    // 马上进入刷新状态
    [self.tableview.mj_header beginRefreshing];
}

- (void)MJFooter
{
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf postTokenWithPage:_pageCount];
    }];
}

-(NSMutableArray *)Level1Arr
{
    if (!_Level1Arr) {
        _Level1Arr = [NSMutableArray array];
    }
    return _Level1Arr;
    
}

-(NSMutableArray *)Level2Arr
{
    if (!_Level2Arr) {
        _Level2Arr = [NSMutableArray array];
    }
    return _Level2Arr;
}

-(NSMutableArray *)tableArr
{
    if (!_tableArr) {
        _tableArr = [NSMutableArray array];
    }
    return _tableArr;
}
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(CGFloatMakeX(10), CGFloatMakeY(40), kWidth-CGFloatMakeX(20), kHeight-CGFloatMakeY(40)-20) style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = NO;
        _tableview.allowsSelection = NO;
    }
    return _tableview;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableArr.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *Identifier = @"cell";
    CKModel * model = self.tableArr[indexPath.row];
    CKTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[CKTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    [cell.avatarVIew sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [cell initWithModel:model];
    return cell;
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
    self.tabBarController.tabBar.hidden =YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(110);
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
