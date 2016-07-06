//
//  MyAddressViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MyAddressViewController.h"
#import "NewAddressViewController.h"
#import "AddressModel.h"
#import "AddressTableViewCell.h"
#import "AFNetworking.h"
#import "UIViewController+CG.h"
#import "MBProgressHUD.h"

@interface MyAddressViewController ()<UITableViewDataSource,UITableViewDelegate,tableViewReflash,editbtnAction>
{
    UIView *messageView;
    UIImageView *imageView;
    UILabel *label1;
    UILabel *label2;
    UITableView *addressTableView;
    UIColor *textcolor;
    NSArray *jsonArr;
    NSArray *dataArr;
}
@property (nonatomic,strong)MBProgressHUD *loadingHud;

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    self.navigationItem.title = @"收货地址管理";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = backcolor;
    
    messageView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 582)];
    messageView.backgroundColor = backcolor;
    [self.view addSubview:messageView];
    
    UIImage *image = [UIImage imageNamed:@"MyAddressicon"];
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame=CGRectMake1(152, 62, 110, 110);
    [messageView addSubview:imageView];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake1(153, 184, 108, 12)];
    label1.text = @"你还没有收货地址喔";
    label1.textColor = textcolor;
    label1.textAlignment = 1;
    label1.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [messageView addSubview:label1];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake1(177, 199, 72, 12)];
    label2.text = @"快来加一个~";
    label2.textColor = textcolor;
    label2.textAlignment = 1;
    label2.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
    [messageView addSubview:label2];
    
    addressTableView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 0, 414, 590)];
    addressTableView.backgroundColor = backcolor;
    addressTableView.delegate = self;
    addressTableView.dataSource = self;
    addressTableView.showsVerticalScrollIndicator = NO;
    [addressTableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"address"];
    addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [messageView addSubview:addressTableView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake1(0, 590, 414, 1)];
    line.backgroundColor = fontcolor;
    [self.view addSubview:line];
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.frame = CGRectMake1(125, 600, 164, 50);
    newButton.backgroundColor = btncolor;
    [newButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton.layer setCornerRadius:5];
    [newButton addTarget:self action:@selector(newAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    newButton.titleLabel.font = [UIFont boldSystemFontOfSize:CGFloatMakeY(12*1.3)];
    [self.view addSubview:newButton];

    [self setMBHUD];
    addressTableView.userInteractionEnabled = NO;
    [self postaddress];
    
}

-(void)AddressGet
{
    NSArray *jsonArr1 = [self returnAddress];
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSDictionary *dic in jsonArr1) {
        AddressModel *model1 = [AddressModel new];
        [model1 setValuesForKeysWithDictionary:dic];
        [tempArr addObject:model1];
    }
    dataArr = [NSArray arrayWithArray:tempArr];
    
    if (dataArr.count != 0)
    {
        imageView.hidden = YES;
        label1.hidden = YES;
        label2.hidden = YES;
        addressTableView.hidden = NO;
        [addressTableView reloadData];
    }
    else
    {
        imageView.hidden = NO;
        label1.hidden = NO;
        label2.hidden = NO;
        addressTableView.hidden = YES;
    }
    [_loadingHud hideAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"address"];
    AddressModel *model1 = dataArr[indexPath.row];
    cell.delegate = self;
    cell.nameLabel.text =model1.realname;
    cell.phoneLabel.text = model1.mobile;
    cell.idcardStr = model1.idcard;
    cell.provinceStr = model1.province;
    cell.cityStr = model1.city;
    cell.areaStr = model1.area;
    cell.fullAddressStr = model1.address;
    cell.mid = [self returnMid];
    cell.aid = model1.aid;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@.\n%@",model1.province,model1.city,model1.area,model1.address,model1.idcard];
    cell.tag = indexPath.row;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.addressLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cell.addressLabel.text.length)];
    cell.addressLabel.attributedText = str;
    if ([model1.isdefault isEqualToString:@"1"]) {
        [cell.button setBackgroundImage:[UIImage imageNamed:@"addressicon01"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.button setBackgroundImage:[UIImage imageNamed:@"addressicon02"] forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGFloatMakeY(161);
}

-(void)postaddress

{   NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid]};
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
 
    [manager POST:kShow parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSArray *jsonArr1 = [NSArray arrayWithArray:responseObject];
        [self setAddresswithAddress:jsonArr1];
        [self AddressGet];
        addressTableView.userInteractionEnabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)newAddressAction:(UIButton*)button
{
    NewAddressViewController *newaddVC = [NewAddressViewController new];
    newaddVC.delegate = self;
    newaddVC.mid = [self returnMid];
    newaddVC.isedit = NO;
    [self.navigationController pushViewController:newaddVC animated:YES];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)reflash
{
    [self setMBHUD];
    addressTableView.userInteractionEnabled = NO;
    [self postaddress];
}

-(void)editBtnActionWithAid:(NSString *)aid WithName:(NSString *)name WithPhone:(NSString *)phone WithIdCard:(NSString *)idcard WithProvince:(NSString *)province WithCity:(NSString *)city WithArea:(NSString *)area Withfulladdress:(NSString *)fulladdress
{
        NewAddressViewController *newaddVC = [NewAddressViewController new];
        newaddVC.delegate = self;
        newaddVC.isedit = YES;
        newaddVC.mid = [self returnMid];
        newaddVC.aid = aid;
        newaddVC.editnameStr = name;
        newaddVC.editphoneStr = phone;
        newaddVC.editidcardStr = idcard;
        newaddVC.editprovinceStr = province;
        newaddVC.editcityStr = city;
        newaddVC.editareaStr = area;
        newaddVC.editfulladdressStr = fulladdress;
        [self.navigationController pushViewController:newaddVC animated:YES];
}

-(void)tableViewReflash
{
    [self setMBHUD];
    addressTableView.userInteractionEnabled = NO;
    [self postaddress];
}

#pragma mark -- 加载动画
-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:addressTableView animated:YES];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel *model1 = dataArr[indexPath.row];
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"aid":model1.aid};
    [self setMBHUD];
    [self postDefaultWith:dic];
}

-(void)postDefaultWith:(NSDictionary*)dic
{
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
    //传入的参数
    //发送请求
    [manager POST:kSetDefault parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [self postaddress];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
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
