//
//  UPJSearchViewController.m
//  UPJStore
//
//  Created by upj on 16/6/30.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "UPJSearchViewController.h"
#import "SearchModel.h"
#import "waitSearchCell.h"
#import "AfterSearchViewController.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"
#import "AFNetworking.h"

@interface UPJSearchViewController () <UISearchBarDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,waitSearchDelegate>

@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) UITableView* searchTableView;
@property (nonatomic,strong) NSMutableArray *someThingArr;
@property (nonatomic,assign) CGFloat tableViewCellHeight,tableViewCellHeight0,tableViewCellHeight1;
@property (nonatomic,strong) NSMutableArray *searchRecordArr;
@property (nonatomic,strong) NSUserDefaults * userdefault;
@property (nonatomic,assign)    BOOL shouldBeginEditing;
@property (nonatomic,strong) NSArray * reArr;
@property (nonatomic,strong) UIView * reloadView;
@property (nonatomic,strong)UIView *noNetworkView;

@end

@implementation UPJSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



-(NSMutableArray *)someThingArr
{
    if (!_someThingArr) {
        _someThingArr = [NSMutableArray array];
    }
    return _someThingArr;
}

-(NSArray *)reArr
{
    if (!_reArr) {
        _reArr = [NSArray array];
    }
    return _reArr;
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
