//
//  appraiseViewController.m
//  UPJStore
//
//  Created by upj on 16/4/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AppraiseViewController.h"
#import "appraiseModel.h"
#import "AppraiseTableViewCell.h"

@interface AppraiseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * heightArr;
@end

@implementation AppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"大家都这样评价~";
    _heightArr = [NSMutableArray array];
    self.view. backgroundColor = [UIColor whiteColor];
    if (_appraiseArr == nil) {
        
    }else
           [self.view addSubview:self.tableView];
 
    
    
    // Do any additional setup after loading the view.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _appraiseArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightArr.count == 0 || _heightArr.count<=indexPath.row) {
        return 100;
    }
    return  [_heightArr[indexPath.row] floatValue]+10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *Identifier = @"cell";
    AppraiseTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[AppraiseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.model = (appraiseModel *)_appraiseArr[indexPath.row];
        [cell initWithModel];
        [_heightArr addObject:[NSNumber numberWithFloat:cell.frame.size.height]];
        
    }
    
    return cell;
}


-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
