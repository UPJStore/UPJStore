//
//  ModifyViewController.m
//  UPJStore
//
//  Created by upj on 16/5/20.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ModifyViewController.h"
#import "UIViewController+CG.h"
#import "ModifyTableViewCell.h"
#import "ModifyNicknameViewController.h"
#import "ModifyRealnameViewController.h"

@interface ModifyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arr;
    NSArray *arr2;
    UITableView *modifyTableView;
}
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    //例行navigationcontroller设置
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"个人资料修改";
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui_@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = backcolor;

    arr = @[@"用户名",@"昵称",@"真实姓名",@"手机号码"];
    arr2 = @[[self returnPhoneNumber],[self returnNickName],[self returnRealName],[self returnPhoneNumber]];
    
    modifyTableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0, 414,736) style:UITableViewStylePlain];
    modifyTableView.delegate = self;
    modifyTableView.dataSource = self;
    modifyTableView.showsVerticalScrollIndicator = NO;
    modifyTableView.showsHorizontalScrollIndicator = NO;
    modifyTableView.backgroundColor = backcolor;
    [modifyTableView registerClass:[ModifyTableViewCell class] forCellReuseIdentifier:@"ModifyCell"];
    //modifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    modifyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:modifyTableView];
    
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0||indexPath.row == 3) {
        ModifyTableViewCell *cell = [[ModifyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ModifyCell"isArrow:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.titleLabel.text = arr[indexPath.row];
        if ([arr2[indexPath.row]isEqualToString:@"0"]) {
            cell.messageLabel.text = @"";
        }else{
            cell.messageLabel.text = arr2[indexPath.row];
        }
        
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 59.5, 414, 0.5)];
    //    lineView.backgroundColor = [UIColor grayColor];
     //   [cell addSubview:lineView];
        
        return cell;
    }
    else
    {
        ModifyTableViewCell *cell = [[ModifyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ModifyCell"isArrow:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.titleLabel.text = arr[indexPath.row];
        if ([arr2[indexPath.row]isEqualToString:@"0"]) {
            cell.messageLabel.text = @"";
        }else{
            cell.messageLabel.text = arr2[indexPath.row];
        }
        
   //     UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake1(0, 59.5, 414, 0.5)];
   //     lineView.backgroundColor = [UIColor grayColor];
   //     [cell addSubview:lineView];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
        {
            ModifyNicknameViewController *MNVC = [ModifyNicknameViewController new];
            [self.navigationController pushViewController:MNVC animated:YES];
        }
            break;
        case 2:
        {
            ModifyRealnameViewController *MRVC = [ModifyRealnameViewController new];
            [self.navigationController pushViewController:MRVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    arr = @[@"用户名",@"昵称",@"真实姓名",@"手机号码"];
    arr2 = @[[self returnPhoneNumber],[self returnNickName],[self returnRealName],[self returnPhoneNumber]];
    [modifyTableView reloadData];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
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
