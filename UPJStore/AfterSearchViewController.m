//
//  AfterSearchViewController.m
//  UPJStore
//
//  Created by upj on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AfterSearchViewController.h"
#import "AFNetWorking.h"
#import "SearchModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+CG.h"
#import "SearchGoodsCollectionViewCell.h"
#import "GoodSDetailViewController.h"
#import "XLPlainFlowLayout.h"

@interface AfterSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionView * goodsCollectionView;
@property (nonatomic,strong) NSMutableArray * goodsArr;
@property (nonatomic,assign) BOOL isUp;
@property (nonatomic,strong) NSArray * arr;
@end

@implementation AfterSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = self.backgroundColor;

    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isFromLBT ==YES)
    {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    }
    [self getDataWithStr:_KeyWord];
    

    _goodsArr =[NSMutableArray array];

    
    // Do any additional setup after loading the view.
}

-(void)initGoodCollectionView
{
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];

    layout.minimumInteritemSpacing = 20;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.sectionInset = UIEdgeInsetsMake(20, 30, 20,30);
    
    _goodsCollectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake1(0, 0,k6PWidth , k6PHeight-60) collectionViewLayout:layout];

    _goodsCollectionView.backgroundColor  = [UIColor whiteColor];
    _goodsCollectionView.delegate  = self;
    _goodsCollectionView.dataSource = self;
    [_goodsCollectionView registerClass:[SearchGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_goodsCollectionView registerClass:[UICollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"header"];
    [_goodsCollectionView registerClass:[UICollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"header1"];

    [self.view addSubview:_goodsCollectionView];
    
}

-(void)getDataWithStr:(NSString *)str
{
    NSDictionary * dic =@{@"appkey":APPkey,@"key":str};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
  
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager POST:kSSearchUrl parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        
       NSArray* arrr = responseObject;
        
        for (NSDictionary *dic in arrr) {
            SearchModel * model = [[SearchModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.goodId = [dic valueForKey:@"id"];
            [_goodsArr addObject: model];
        }
        
        if (arrr.count != 0) {
             [self initGoodCollectionView];
        }
        else
        {
            [self initNoneView];
        }
       
        [self.goodsCollectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        DLog(@"error : %@",error);
        
    }];
    
}

-(void)initNoneView
{
    UIImageView *noneImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(234/2*414.0/320, 263/2*736.0/568, 336/3, 336/3)];
    noneImageView.image = [UIImage imageNamed:@"afterSearchNone"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake1(70/2*k6PWidth/320, ((39.0/2+263.0/2)*k6PHeight/568+336/3), k6PWidth-70*k6PWidth/320, 60*k6PHeight/568)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抱歉，没有找到与“%@”相关的商品，你可以换个词试试",_KeyWord]];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor  colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] range:NSMakeRange(9, _KeyWord.length)];
    label.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        label.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
     label.attributedText = aStr;

    [self.view addSubview:label];
    
    [self.view addSubview: noneImageView];
    
}


//确定每个item的大小.
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake1(150, 200);
    
}

//一共有几个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_isFromLBT) {
        return 2;
    }else
        
    return 1;
}

#pragma mark -- 分区头分区尾

//分区头
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_isFromLBT) {
    if (section == 0) {
        return CGSizeMake1(k6PWidth, 275);
    }else
        return CGSizeMake1(k6PWidth, 40);
        
    }else
        
        return CGSizeMake1(k6PWidth, 40);

}

//什么样的分区头或者分区尾
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    if (_isFromLBT) {
        if (indexPath.section == 0) {
            
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header1" forIndexPath:indexPath];
                if (headerView.subviews.count < 1) {
                    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 0, 414, 195)];
                    
                    [headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,_thumb]]];
                    
                    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10,196, 414-20,80)];
                    selectLabel.text = _descriptionText;
                    selectLabel.numberOfLines = 0;
                    selectLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
                    selectLabel.textAlignment = NSTextAlignmentCenter;
                    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
                    selectLabel.textColor = fontcolor;
                    
                    UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(276), self.view.bounds.size.width, 1)];
                    linelabel.backgroundColor = fontcolor;
                    
                    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 50)];
                    view2.backgroundColor = [UIColor blackColor];
                    
                    [headerView addSubview:headerImgView];
                    [headerView addSubview:selectLabel];
                    [headerView addSubview:linelabel];                }
                return headerView;
            
        
        }
    else
        {
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                if (headerView.subviews.count < 1) {
                    _arr = @[@"最新",@"人气",@"销量",@"价格",@"价格▲",@"价格▼"];
                    
                    for(int i = 0; i<4;i++)
                    {
                        
                        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
                        if (i==0) {
                            [btn setSelected:YES];
                            [self isFromWhat:1000];
                        }
                        btn.frame = CGRectMake(i*headerView.frame.size.width/4, 0, headerView.frame.size.width/4, CGFloatMakeY(40));
                        btn.tag = 1000+i;
                        [btn setTitle:_arr[i] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] forState:UIControlStateSelected];
                        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                        btn.layer.borderWidth = 0.5;
                        btn.layer.borderColor = [[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1]CGColor];
                        [headerView addSubview:btn];
                        headerView.tag = 2000 +i;
                        
                    }
                    
                    headerView.backgroundColor =[UIColor whiteColor];
                    
                }
                return headerView;
        
        
        }
    }
    else
        
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            if (headerView.subviews.count < 1) {
                _arr = @[@"最新",@"人气",@"销量",@"价格",@"价格▲",@"价格▼"];
                
                for(int i = 0; i<4;i++)
                {
                    
                    UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (i==0) {
                        [btn setSelected:YES];
                        [self isFromWhat:1000];
                    }
                    btn.frame = CGRectMake(i*headerView.frame.size.width/4, 0, headerView.frame.size.width/4, CGFloatMakeY(40));
                    btn.tag = 1000+i;
                    [btn setTitle:_arr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] forState:UIControlStateSelected];
                    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                    btn.layer.borderWidth = 0.5;
                    btn.layer.borderColor = [[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1]CGColor];
                    [headerView addSubview:btn];
                    headerView.tag = 2000 +i;
                    
                }
                
                headerView.backgroundColor =[UIColor whiteColor];
                
            }
            return headerView;
        }
    }
        return nil;
}



//每个分区有几个ITEM
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isFromLBT) {
        if (section == 0) {
            return 0;
        }else
            return self.goodsArr.count;
    }else
        
    return  self.goodsArr.count;
}

//每个ITEM显示什么样的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    SearchModel *Model =self.goodsArr[indexPath.row];
    
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSImageUrl,Model.thumb]]];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",Model.marketprice];
    cell.goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.titleLabel.text = Model.title;
    
    //    cell.backgroundColor =[UIColor redColor];
    
    return cell;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)btnAction:(UIButton *)btn
{
    _goodsArr =[NSMutableArray arrayWithArray: [self isFromWhat:btn.tag]];
    
    for (UIButton * button in btn.superview.subviews)
    {
        [button setSelected:NO];
    }
    [btn setSelected:YES];
    if (btn.tag != 1003) {
        [(UIButton*)[btn.superview viewWithTag:1003] setSelected:NO];
    }
    if (btn.tag == 1003) {
        [btn setSelected:YES];
        if (_isUp == NO)
        {
            [btn setTitle:_arr[4] forState:UIControlStateSelected];
            _isUp = YES;
        }else
        {
            [btn setTitle:_arr[5] forState:UIControlStateSelected];
            _isUp = NO;
        }
    }


    [_goodsCollectionView reloadData];
    
}

-(NSArray*)isFromWhat:(NSInteger)tag
{
    
    NSArray *sortedArray = [_goodsArr sortedArrayUsingComparator:^(SearchModel *number1,SearchModel *number2) {
        int val1,val2;
        switch (tag) {
            case 1000:
            {
                val1 = [number1.createtime intValue];
                
                val2 = [number2.createtime intValue];
            }
                break;
            case 1001:
            {
                val1 = [number1.viewcount intValue];
                
                val2 = [number2.viewcount intValue];
            }
                break;
                
            case 1002:
            {
                val1 = [number1.sales intValue];
                
                val2 = [number2.sales intValue];
            }
                break;
                
            case 1003:
            {
                val1 = [number1.marketprice intValue];
                
                val2 = [number2.marketprice intValue];
            }
                break;

            default:
                break;
        }
        
        if (val1 > val2) {
            if (tag == 1003 && _isUp == YES)
            {
                return NSOrderedDescending;
            }else
            return NSOrderedAscending;
            
        } else {
            
            if (tag == 1003 && _isUp == YES)
            {
                return NSOrderedAscending;
            }else
            return NSOrderedDescending;
            
        }
        
        
        
    }];
    return sortedArray;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel *Model =self.goodsArr[indexPath.row];
    
    GoodSDetailViewController * goodDetailVC = [[GoodSDetailViewController alloc]init];
    goodDetailVC.goodsDic = @{@"id":Model.goodId,@"appkey":APPkey};
    self.navigationItem.title = @"";
   
    [self.navigationController pushViewController:goodDetailVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isFromLBT) {
        self.navigationItem.title = _advname;
    }else
        self.navigationItem.title = _KeyWord;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)pop
{
    
    self.navigationController.navigationBar.translucent = NO;
    
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
