//
//  AgentsViewController.m
//  UPJStore
//
//  Created by upj on 16/7/12.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AgentsViewController.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@interface AgentsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *agentCollectionView;
    NSArray *arr;
}

@end

@implementation AgentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden =YES;
    self.navigationItem.title = @"合作商管理平台";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    arr = @[@"采购商品",@"采购记录",@"账号信息",@"我的店铺",@"店铺商品",@"店铺订单",@"店铺二维码",@"下级合作商",@"下级采购",@"下级订单",@"收益统计"];
    
    UIButton *headViewBtn = [[UIButton alloc]initWithFrame:CGRectMake1(0, 0, 414, 90)];
    headViewBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headViewBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(20, 10, 70, 70)];
    imageView.image = [UIImage imageWithData:[self returnImageData]];
    [headViewBtn addSubview:imageView];
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    
    agentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake1(0, 90, 414,586) collectionViewLayout:layout];
    
    agentCollectionView.backgroundColor = [UIColor whiteColor];
    agentCollectionView.delegate = self;
    agentCollectionView.dataSource = self;
    agentCollectionView.showsVerticalScrollIndicator = NO;
    [agentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collcell"];
    agentCollectionView.contentSize = CGSizeMake1(414, 600);
    [self.view addSubview:agentCollectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 11;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collcell" forIndexPath:indexPath];
    cell.layer.borderColor=[UIColor colorFromHexRGB:@"d9d9d9"].CGColor;
    cell.layer.borderWidth=0.3;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(78.5, 10, 50, 50)];
    imageView.layer.cornerRadius = CGFloatMakeY(25);
    [cell addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(0, 70, 207, 27.5)];
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    if(indexPath.row == 10)
    {
        imageView.frame = CGRectMake1(182, 10, 50, 50);
        label.frame = CGRectMake1(0, 70, 414, 27.5);
    }
    label.text = arr[indexPath.row];
    label.textAlignment = 1;
    [cell addSubview:label];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 10) {
        return CGSizeMake1(414, 97.5);
    }else
    {
        return CGSizeMake1(207, 97.5);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
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
