//
//  ShoppingCartViewController.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/16.
//  Copyright © 2016年 UPJApp. All rights reserved.
//
#import "AppDelegate.h"
#import "ShoppingCartViewController.h"
#import "recommendCollectionViewCell.h"
#import "recommendGoodsModel.h"
#import "UIViewController+CG.h"
#import "HeardView.h"
#import "GoodSDetailViewController.h"
#import "ConfirmOrderViewController.h"

@interface ShoppingCartViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,ShoppingCarCellDelegate,ShoppingCartEndViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UICollectionView * goodsCollectionView;

@property (nonatomic,strong) NSMutableArray * modelArr;

//登录状态的属性
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * carDataList;
@property (nonatomic,strong) UIToolbar * toolbar;
@property (nonatomic,strong) UIBarButtonItem *previousBarButton;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) ShoppingCartEndView * endView;
@property (nonatomic,strong) ShopViewModel * vm;

@end

@interface ShoppingCartViewController ()

{
    UIView * noneCart;
}
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"购物车";

    //    DLog(@"viewdidload");
    
    if ([self returnMid]==nil||[[self returnMid]isEqualToString:@"0"])
    {
        [self setMidwithMid:@"0"];
        [self isNoneCart];
    }else
    {
        [self getDataWithDic:@{@"appkey":APPkey,@"mid":[self returnMid]}];
        
    }
    
}


-(void)isNoneCart
{

    noneCart = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, CGFloatMakeY(260))];
    noneCart.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    
    UIImageView * shoppingCartIcon = [[UIImageView alloc]initWithFrame:CGRectMake1(0,0, 200, 160)];
    shoppingCartIcon.contentMode = UIViewContentModeScaleAspectFit;
    shoppingCartIcon.center  = CGPointMake(kWidth/2, CGFloatMakeY(90));
    shoppingCartIcon.image = [UIImage imageNamed:@"shoppingCar"];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 160, 40)];
    titleLabel.center = CGPointMake(kWidth/2, CGFloatMakeY(190));
    titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    titleLabel.text = @"亲，购物车还是空的哟，赶紧行动吧~！";
    titleLabel.lineBreakMode = 0;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake1(0, 0, 100, 30);
    btn.center = CGPointMake(kWidth/2, CGFloatMakeY(235));
    [btn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToHomePage:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"去逛逛" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(18)];
    
    
    
    [noneCart addSubview:btn];
    [noneCart addSubview:titleLabel];
    [noneCart addSubview: shoppingCartIcon];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kWidth,kHeight+CGFloatMakeY(260));
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    
    [_scrollView addSubview:noneCart];
    [self.view addSubview:_scrollView];
    
    
    UIImageView *spView = [[UIImageView alloc]initWithFrame:CGRectMake1(0, 260, 414, 40)];
    spView.contentMode = UIViewContentModeScaleAspectFit;
    spView.image  = [UIImage imageNamed:@"line"];
    [_scrollView addSubview:spView];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumInteritemSpacing = 25;
    
    layout.itemSize = CGSizeMake1(150, 250);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
    
    _modelArr = [NSMutableArray arrayWithCapacity:60];
    
    [self getData];
    
    
    _goodsCollectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0,CGFloatMakeY(300), kWidth, kHeight-64-60-25) collectionViewLayout:layout];
    _goodsCollectionView.backgroundColor = [UIColor whiteColor];
    _goodsCollectionView.showsVerticalScrollIndicator = NO;
    _goodsCollectionView.scrollEnabled = NO;
    _goodsCollectionView.delegate = self;
    _goodsCollectionView.dataSource = self;
    
    [_goodsCollectionView registerClass:[recommendCollectionViewCell class] forCellWithReuseIdentifier:@"recommendCell"];
    
    [_scrollView addSubview:_goodsCollectionView];
    
}

-(void)getData
{
 
    [self endViewHidden];
    
    NSDictionary * dic =@{@"appkey":APPkey,@"mid":[self returnMid]} ;
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager POST:kSNet parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
        //             DLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray * arr = responseObject;
        if (_modelArr.count != 0)
        {
            [_modelArr removeAllObjects];
            
        }
        for (NSDictionary *dic in arr) {
            
            recommendGoodsModel * Model = [[recommendGoodsModel alloc]init];
            
            [Model setValuesForKeysWithDictionary:dic];
            
            Model.goodsId = [dic valueForKey:@"id"];
            
            //            DLog(@"%@",Model.marketprice);
            
            if (Model.thumb != nil) {
                
                [_modelArr addObject:Model];
                
            }
        }
        
        
        
        [self.goodsCollectionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                DLog(@"%@",error);
    }];
    
}

-(void)finshBarView
{
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, CGFloatMakeY(44))];
    [_toolbar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * flexBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.previousBarButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
    NSArray * barButtonItems = @[flexBarButton,self.previousBarButton];
    _toolbar.items = barButtonItems;
    _toolbar.tag = 10000;
    [self.view addSubview:_toolbar];
}

-(void)previousButtonIsClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}

-(void)numPrice
{
    NSArray * lists = [_endView.Lab.text componentsSeparatedByString:@"￥"];
    
    float num = 0.00;
    for (int i=0; i<self.carDataList.count; i++) {
        NSArray *list = [self.carDataList objectAtIndex:i];
        for (int j = 0; j<list.count-1; j++) {
            ShoppingCarModel *model = [list objectAtIndex:j];
            NSInteger count = [model.model.total integerValue];
            float sale = [model.model.marketprice floatValue];
            if (model.isSelect) {
                num = count*sale+ num;
            }
        }
    }
    _endView.Lab.text = [NSString stringWithFormat:@"%@￥%.2f",lists[0],num];
    
}

-(ShoppingCartEndView *)endView
{
    if (!_endView) {
   
        _endView = [[ShoppingCartEndView alloc]initWithFrame:CGRectMake(0, kHeight-49-60- [ShoppingCartEndView getViewHeight], kWidth, [ShoppingCartEndView getViewHeight])];
        if (_isFromDetail == YES) {
            _endView.frame = CGRectMake(0, self.view.frame.size.height-_endView.frame.size.height, kWidth, _endView.frame.size.height);
        }
        _endView.delegate = self;
        _endView.isEdit =_isEdit;
    }
    return _endView;
}

-(void)clickAllEnd:(UIButton *)btn
{
    btn.selected = !btn.selected;
    BOOL btselected = btn.selected;
    NSString * checked = @"";
    if (btselected) {
        checked =@"YES";
    }else
    {
        checked = @"NO";
        
    }
    if (self.isEdit) {
        for (int i = 0; i<_carDataList.count; i++) {
            NSArray *dataList = [_carDataList objectAtIndex:i];
            NSMutableDictionary * dic = [dataList lastObject];
            [dic setObject:checked forKey:@"checked"];
            for (int j = 0 ; j<dataList.count-1; j++) {
                ShoppingCarModel * model = (ShoppingCarModel*) [dataList objectAtIndex:j];
                model.isSelect =btselected;
                
                NSDictionary *dic = @{@"appkey":APPkey,@"id":model.model.listId,@"mid":[self returnMid],@"checked":[NSString stringWithFormat:@"%d",btselected]};
                //                DLog(@"dic = %@",dic);
                [self postCheckInCartWithDic:dic];
            }
        }
    }
    else
    {
        for (int i = 0 ; i< _carDataList.count; i++) {
            NSArray * dataList = [_carDataList objectAtIndex:i];
            NSMutableDictionary * dic =[dataList lastObject];
            [dic setObject:checked forKey:@"checked"];
            for (int j = 0; j<dataList.count-1; j++) {
                
                ShoppingCarModel * model = (ShoppingCarModel*) [dataList objectAtIndex:j];
                model.isSelect =btselected;
                
                NSDictionary *dic = @{@"appkey":APPkey,@"id":model.model.listId,@"mid":[self returnMid],@"checked":[NSString stringWithFormat:@"%d",btselected]};
                //                DLog(@"dic = %@",dic);
                [self postCheckInCartWithDic:dic];
                
            }
        }
    }
    [_tableView reloadData];
}

-(void)clickRightBtn:(UIButton *)btn
{
    if (btn.tag == 19) {
        for (int i = 0 ; i<_carDataList.count; i++) {
            NSMutableArray *arr= [_carDataList objectAtIndex:i];
            DLog(@"arr = %@",arr);
            for (int j = 0; j < arr.count-1 ; j++) {
                DLog(@"j = %d",j);
                ShoppingCarModel *model = [arr objectAtIndex:j];
                DLog(@"model : %@",model);
                DLog(@" bool = %@",model.model.is_choose);
                
                NSDictionary * goodDic = @{@"appkey":APPkey,@"id":model.model.listId,@"mid":[self returnMid]};
                DLog(@"goodDic : %@",goodDic);
                if (model.isSelect ==YES)
                {

                    DLog(@" id = %@",goodDic[@"id"]);
                    [self deleteGoodsInShoppingCart:goodDic];
                    
                }

            }
        }
 

    }
    else if (btn.tag == 18)
    {
        NSDictionary * dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
        
        [self postOrderWtihDic:dic];
    }
}


-(void)postOrderWtihDic:(NSDictionary *)dic
{
 
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kOrder parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        
        if ([(NSDictionary *)responseObject count]<3)
        {
            UIAlertController * ACVC = [UIAlertController alertControllerWithTitle:@"你还没选择商品喔" message:nil preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction * okAC =  [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [self presentViewController:ACVC animated:YES completion:^{
                
            }];
            [ACVC addAction:okAC];
        }else
        {
        ConfirmOrderViewController *conFirVC = [[ConfirmOrderViewController alloc]init];
        conFirVC.dic = dic;
        [self.navigationController pushViewController:conFirVC animated:YES];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}


-(void)edits:(UIBarButtonItem *)item
{
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        item.title = @"取消";
        
    }
    else {
        item.title = @"编辑";
            }
    
    _endView.isEdit = self.isEdit ;
    [_vm pitchOn:_carDataList];
    [_tableView reloadData];
}

- (NSMutableArray *)carDataList
{
    if (!_carDataList) {
        _carDataList = [NSMutableArray array];
    }
    return _carDataList;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight-[ShoppingCartEndView getViewHeight]-60-49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.userInteractionEnabled=YES;
        _tableView.dataSource = self;
        _tableView.scrollsToTop=YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorFromHexRGB:@"e2e2e2"];
    }
    return _tableView;
}
- (void)endViewHidden
{
    if (_carDataList.count==0) {
        self.endView.hidden=YES;
    }
    else
    {
        self.endView.hidden=NO;
    }
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self endViewHidden];
    return self.carDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * arr = [self.carDataList objectAtIndex:section];
    return  arr.count-1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGFloatMakeY(50);
    }else
    {
        return CGFloatMakeY(40);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFloatMakeY(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    __weak typeof (ShopViewModel) *vm  = _vm;
    __weak typeof (NSMutableArray) *carDataArrList = _carDataList;
    __weak typeof (UITableView) *tableViews= _tableView;
    HeardView* heardView = [[HeardView alloc]initWithFrame:CGRectMake(0, 0, kWidth, CGFloatMakeY(40)) section:section carDataArrList:_carDataList block:^(UIButton *bt) {
        [vm clickAllBT:carDataArrList bt:bt];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:bt.tag-100];
        
        NSArray * dataList = [_carDataList objectAtIndex:0];
        NSMutableDictionary * dic =[dataList lastObject];

        for (int j = 0; j<dataList.count-1; j++) {
            
            ShoppingCarModel * model = (ShoppingCarModel*) [dataList objectAtIndex:j];
            model.isSelect =[[dic valueForKey:@"checked"] boolValue];
            
            NSDictionary *dic = @{@"appkey":APPkey,@"id":model.model.listId,@"mid":[self returnMid],@"checked":[NSString stringWithFormat:@"%d",model.isSelect]};
                            DLog(@"dic = %@",dic);
            [self postCheckInCartWithDic:dic];
            
        }
        
        [tableViews reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    heardView.tag = 1999+section;
    heardView.backgroundColor = [UIColor whiteColor];
    return heardView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY([ShoppingCarTableViewCell getHeight]);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * shoppingCaridentis = @"ShoppingCarCells";
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCaridentis];
    if (!cell)
    {
        cell = [[ShoppingCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCaridentis tableView:tableView];
        cell.delegate = self;
    }
    if (self.carDataList.count>0) {
        cell.isEdit =self.isEdit ;
        NSArray *list = [self.carDataList objectAtIndex:indexPath.section];
        cell.row =indexPath.row+1;
        [cell setModel:[list objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (list.count -2 !=indexPath.row) {
            UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(CGFloatMakeX(40), [ShoppingCarTableViewCell getHeight]-0.5, kWidth-CGFloatMakeX(45), 0.5)];
            line.backgroundColor = [UIColor colorFromHexRGB:@"e2e2e2"];
            [cell addSubview:line];
        }
    }
    return cell;
}




-(void)singleClick:(ShoppingCarModel *)models row:(NSInteger)row
{
    [_vm pitchOn:_carDataList];
    NSString *checktype;
    
   
        NSIndexSet * indexSet = [[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//        if ( [[(NSDictionary*)[_carDataList[0]lastObject] valueForKey:@"checked"]isEqualToString:@"YES"]) {
//            checktype = @"1";
//        }
//        else checktype = @"0";
    
    if ( models.isSelect == YES) {
        checktype = @"1";
    }
    else checktype = @"0";
    
    
    NSDictionary *dic = @{@"appkey":APPkey,@"id":models.model.listId,@"mid":[self returnMid],@"checked":checktype};
    
    [self postCheckInCartWithDic:dic];
}


-(void)postCheckInCartWithDic:(NSDictionary *) dic
{
    #pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    if (self.loadingHud != nil) {
        
    }else
    [self setMBHUD];
    AFHTTPSessionManager * manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    DLog(@"dic = %@",dic);
    [manager POST:kCheck parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
        [self numPrice];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


//删除用到的函数
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray * list = [_carDataList objectAtIndex:indexPath.section];
        ShoppingCarModel * model = [list objectAtIndex:indexPath.row];
        model.isSelect = NO;
        [list removeObjectAtIndex:indexPath.row];
        if (list.count == 1) {
            
            [_carDataList removeObjectAtIndex:indexPath.section];
            
        }
        NSDictionary * goodDic = @{@"appkey":APPkey,@"id":model.model.listId,@"mid":[self returnMid]};
        
        [self deleteGoodsInShoppingCart:goodDic];
        

    }
}


-(void)deleteGoodsInShoppingCart:(NSDictionary *)dic
{
    if (self.loadingHud != nil) {
        
    }else
        [self setMBHUD];
    #pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager * manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kSDeleGoods parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
               [self getDataWithDic:@{@"appkey":APPkey,@"mid":[self returnMid]}];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}

-(void)dealloc
{
    _tableView = nil;
    _tableView.dataSource=nil;
    _tableView.delegate=nil;
    self.vm = nil;
    self.endView = nil;
    self.carDataList = nil;
    //    DLog(@"Controller释放了。。。。。");
}

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        //        DLog(@"%ld",sub.tag);
        CGFloat maxY = CGRectGetMaxY(sub.frame);
        if ([sub isKindOfClass:[UITableView class]]) {
            
            sub.frame = CGRectMake(0, 0, sub.frame.size.width, kHeight-_toolbar.frame.size.height-rect.size.height);
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/2);
            
        }else{
            if (maxY > y - 2) {
                sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y - maxY + y -59);
            }
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.view.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        }
    }
    _toolbar.frame=CGRectMake(0, kHeight-49, kWidth, _toolbar.frame.size.height);
    if (_isFromDetail == YES) {
           _endView.frame = CGRectMake(0, self.view.frame.size.height-_endView.frame.size.height, kWidth, _endView.frame.size.height);
    }else
    _endView.frame = CGRectMake(0, self.view.frame.size.height-_endView.frame.size.height-49, kWidth, _endView.frame.size.height);
    
    self.tableView.frame=CGRectMake(0, 0, self.tableView.frame.size.width, kHeight-[ShoppingCartEndView getViewHeight]-49);
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

//确定每个item的大小.
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake1(150, 180);
    
}

//一共有几个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

//每个分区有几个ITEM
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.modelArr.count;
}

//每个ITEM显示什么样的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    recommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendCell" forIndexPath:indexPath];
    
    cell.goodsView.image = [UIImage imageNamed:@"shopping"];

    
    recommendGoodsModel *Model =self.modelArr[indexPath.row];
    
    NSString * imgStr = [NSString stringWithFormat:@"http://www.upinkji.com/resource/attachment/%@",Model.thumb];
    
    [cell.goodsView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"lbtP"]];
    
    cell.titleLabel.text = Model.title;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",Model.marketprice];
    
    
    //        cell.backgroundColor =[UIColor redColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    recommendGoodsModel * model = _modelArr[indexPath.row];
    
    GoodSDetailViewController * goodsVC = [[GoodSDetailViewController alloc]init];
    
    NSDictionary *dic = @{@"appkey":APPkey,@"id":model.goodsId};
    
    goodsVC.goodsDic = dic;
    
    [self.navigationController pushViewController:goodsVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"scrollview  %f",_scrollView.contentOffset.y);
    DLog(@"goodsCollectionView %f",_goodsCollectionView.contentOffset.y);
    
    if (scrollView == _goodsCollectionView) {
        if (scrollView.contentOffset.y < CGFloatMakeY(-60))
        {
            
            _goodsCollectionView.scrollEnabled = NO;
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            _scrollView.contentOffset = CGPointMake(0,0);
            [UIView commitAnimations];
            _scrollView.scrollEnabled = YES;
            
        }
        
    }else if (scrollView == _scrollView){
        if (_scrollView.contentOffset.y >= CGFloatMakeY(260))
        {
            
            _goodsCollectionView.scrollEnabled = YES;
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            _scrollView.contentOffset = CGPointMake(0,CGFloatMakeY(260));
            
            [UIView commitAnimations];
            _scrollView.scrollEnabled = NO;
        }
    }

    
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

-(void)goToHomePage:(UIButton *)btn
{
    //跳转到tabBarController的子视图
    self.tabBarController.selectedIndex = 0;
}


-(void)getDataWithDic:(NSDictionary *)dic
{
    if (self.loadingHud != nil) {
        
    }else
        [self setMBHUD];
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:kSURL parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        DLog(@"tableview !!!!!!!!!!!! %@",_tableView);

        NSDictionary * Rdic = responseObject;
        if ([(NSArray *)[Rdic valueForKey:@"data"] count]!=0) {
            _scrollView.hidden = YES;
            
            if(_tableView == nil){
                _vm = [[ShopViewModel alloc]init];
                [self.view addSubview:self.tableView];
                [self.view addSubview:self.endView];
                
                __weak typeof (ShoppingCartViewController *)waks = self;
                __weak typeof (NSMutableArray )* carDataList = self.carDataList;
                __weak typeof (UITableView) *tableView = self.tableView;
                
                [_vm getShopData:^(NSArray *commonArry) {
                    [carDataList addObject:commonArry];
                    [tableView reloadData];
                    [waks numPrice];
                } priceBlock:^{
                    [waks numPrice];
                } WithDic:Rdic];
                
                [self finshBarView];
                [self loadNotificationCell];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edits:)];
               DLog(@"self.view1 %@",self.view.subviews);
            }
            else{
                
                if (self.navigationItem.rightBarButtonItem == nil)
                {
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edits:)];
                }
                [_carDataList removeAllObjects];
                
                __weak typeof (ShoppingCartViewController *)waks = self;
                __weak typeof (NSMutableArray )* carDataList = self.carDataList;
                __weak typeof (UITableView) *tableView = self.tableView;
                
                [_vm getShopData:^(NSArray *commonArry) {
                    [carDataList addObject:commonArry];
                    [tableView reloadData];
                    [waks numPrice];
                } priceBlock:^{
                    [waks numPrice];
                } WithDic:Rdic];
               DLog(@"self.view2 %@",self.view.subviews);

            }
            
            [self.tableView reloadData];

            DLog(@"self.view3 %@",self.view.subviews);
        }
        else
        {
            
            
            self.scrollView.hidden = NO;
            
            [_carDataList removeAllObjects];
            
            _tableView.hidden =YES;

            self.navigationItem.rightBarButtonItem = nil;
//            _tableView = nil;
            [_tableView reloadData];
            [self getData];
               DLog(@"self.view4 %@",self.view.subviews);
        }
        DLog(@"self.view5 %@",self.view.subviews);
        [self.loadingHud hideAnimated:YES];
        self.loadingHud = nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        DLog(@"failure%@",error);
        
    }];
    
}

-(void)pop
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;

    if (_isFromDetail == YES) {
        self.isShowTab = YES;
        [self hideTabBarWithTabState:self.isShowTab];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    }else
    {  self.isShowTab = NO;
        [self showTabBarWithTabState:self.isShowTab];
    }
    
    self.navigationController.navigationBar.hidden = NO;

    if ([[self returnMid] isEqualToString:@"0"]||[self returnMid]==nil) {
        _tableView.hidden = YES;
        self.scrollView.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
        _carDataList = nil;
        [self endViewHidden];
        _tableView = nil;
    }else
    {
        
        [self getDataWithDic:@{@"appkey":APPkey,@"mid":[self returnMid]}];
        
        _scrollView.hidden =YES;
        _tableView.hidden = NO;

    }
    
    _goodsCollectionView.scrollEnabled = NO;
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    _scrollView.contentOffset = CGPointMake(0,0);
    [UIView commitAnimations];
    _scrollView.scrollEnabled = YES;


}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodSDetailViewController * goodVC = [[GoodSDetailViewController alloc]init];
    
    NSArray * list = [self.carDataList objectAtIndex:indexPath.section];
    
    ShoppingCarModel * model = [list objectAtIndex:indexPath.row];
    
    goodVC.goodsDic = @{@"appkey":APPkey,@"id":model.model.goodsid};
    
    [self.navigationController pushViewController:goodVC animated:YES];
    
}



-(UIScrollView *)scrollView
{
    if (_scrollView ==nil) {
        [self isNoneCart];
    }
    return _scrollView;
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
