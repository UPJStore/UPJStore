//
//  MapViewController.m
//  UPJStore
//
//  Created by upj on 16/3/10.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "MapViewController.h"
#import "UIViewController+CG.h"
#import "MapAddressModel.h"
#import "KCAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    UITableView *_locationTabelView;
    UIScrollView *_backScrollView;
    NSMutableArray *_shopArr;
    CLLocation *cLocation;
    NSMutableArray *_newShopArr;
}
@end

@implementation MapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数组
    _shopArr = [NSMutableArray array];
    _newShopArr = [NSMutableArray array];
    // 设置navigationBar
    self.navigationItem.title = @"门店地址";
  //  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self getAddressData];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self initBackScrollViewAndTabelView];
    [self initLocationService];
    [self initMap];
    
    // Do any additional setup after loading the view.
}
-(void)initBackScrollViewAndTabelView{
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backScrollView.contentSize = CGSizeMake(kWidth, kHeight+1000);
    [self.view addSubview:_backScrollView];
    
    
}
#pragma mark -- 返回
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initLocationService{
    // 1、创建一个位置管理者对象
    _locationManager = [[CLLocationManager alloc]init];
    // 2、判断当前的设备是否为iOS8.0 以后的系统
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        // 让用户授权
        // 一直使用用户的位置
        [_locationManager requestAlwaysAuthorization];
        // 当需要的时候使用用户的文职
        [_locationManager requestWhenInUseAuthorization];
        
        // 定位的一些设置
        
        // 当开始位置更新位置服务后, 多远更新一下位置
        _locationManager.distanceFilter = 10.0f;
        
        // 设置位置的精确度
        _locationManager.desiredAccuracy = 1.0f;
        _locationManager.delegate = self;
        
        // 开启定位服务
        [_locationManager startUpdatingLocation];
        
    }
    
}
-(void)getAddressData{
    
    NSDictionary * dic =@{@"appkey":APPkey};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:AddressURL parameters:Ndic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSArray *arr = [dic mutableArrayValueForKey:@"data"];
        
        for (NSDictionary *dic in arr ) {
            MapAddressModel *model = [[MapAddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_shopArr addObject:model];
        }
        _locationTabelView.frame = CGRectMake1(0,400,414,_shopArr.count*90);
        _backScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-64);
        _backScrollView.contentSize = CGSizeMake1(414,(400+_shopArr.count*90));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}
// 排序
-(NSArray *)paixu{
    for (int i = 0; i<_shopArr.count; i++) {
        MapAddressModel *model = _shopArr[i];
        
        CLLocation *current=[[CLLocation alloc] initWithLatitude:cLocation.coordinate.latitude longitude:cLocation.coordinate.longitude];
        // 第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:model.latitude longitude:model.longitude];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before]/1000;
        
        model.metres = meters;
        
        [_newShopArr addObject:model];
    }
    
    
    NSArray *sortedArray = [_newShopArr sortedArrayUsingComparator:^(MapAddressModel *number1,MapAddressModel *number2) {
        double val1,val2;
        val1 = number1.metres;
        val2 = number2.metres;
        if (val1 > val2) {
            return NSOrderedDescending;
        }else
            return NSOrderedAscending;
    }];
    return sortedArray;
    
}
#pragma mark -- tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseCell"];
    }
    MapAddressModel *model = _newShopArr[indexPath.row];
    
    cell.detailTextLabel.text = model.address;
    
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ | 距离：%.f km.",model.name,model.metres];
    
    [self addAnnotationWithModel:model];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _shopArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    return 90*app.autoSizeScaleY;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}
#pragma mark -- cell点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MapAddressModel *shopModel = _newShopArr[indexPath.row];
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(shopModel.latitude,shopModel.longitude);
    MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region=MKCoordinateRegionMake(location, span);
    [_mapView setRegion:region animated:true];
    [_locationTabelView setScrollsToTop:NO];
    [_backScrollView setScrollsToTop:YES];
    [_backScrollView setContentOffset:CGPointMake(0,0) animated:YES];
}
-(void)initMap{
    CGRect rect= CGRectMake1(0, 0,414,400);
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [_backScrollView addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    //    _mapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
    
    _mapView.showsUserLocation = YES;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    //    [self addAnnotation];
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    DLog(@"%@",userLocation);
    
    cLocation = userLocation.location;
    if (!_locationTabelView) {
        _newShopArr = [NSMutableArray arrayWithArray:[self paixu]];
        _locationTabelView = [[UITableView alloc]initWithFrame:CGRectMake1(0, 400, 414,_shopArr.count*100) style:UITableViewStylePlain];
        _locationTabelView.delegate = self;
        _locationTabelView.dataSource = self;
        _locationTabelView.scrollEnabled = NO;
        [_backScrollView addSubview:_locationTabelView];
        [_locationTabelView reloadData];
    }
    
    // 位置反编码
    // 1. 创建一个位置反编码的对象
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    // 2. 使用位置反编码解析位置信息
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 使用for in 遍历位置的信息
        CLPlacemark *placemark=[placemarks firstObject];
        DLog(@"%@",placemark.addressDictionary);
        for (CLPlacemark *pm in placemarks) {
            DLog(@"name = %@",pm.name);
            DLog(@"street = %@",pm.thoroughfare);
            DLog(@" %@  %@ ",pm.subLocality,pm.subThoroughfare);
            
        }
    }];
    
    //    设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [_mapView setRegion:region animated:true];
    
    // 停止定位
    [_locationManager stopUpdatingLocation];
}


#pragma mark -- 添加大头针
-(void)addAnnotationWithModel:(MapAddressModel *)shopModel{
    //    [_mapView removeOverlays:_mapView.overlays];
    //    [_mapView removeAnnotations:_mapView.annotations];
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(shopModel.latitude,shopModel.longitude);
    KCAnnotation *annotation=[[KCAnnotation alloc]init];
    annotation.title=shopModel.name;
    annotation.subtitle=shopModel.address;
    annotation.coordinate=location;
    
    [_mapView addAnnotation:annotation];
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(location, span);
    //    [_mapView setRegion:region animated:true];
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // 如果是系统的用户位置, 我们不做任何操作
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    // 创建重用标识符
    static NSString *identifier = @"anootation";
    
    // 创建重用队列
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    // 设置大头针的一些属性
    // 设置大头针向下坠落的效果
    pin.animatesDrop = YES;
    // 显示大头针的气泡
    pin.canShowCallout = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
        pin.pinTintColor = [UIColor redColor];
    }else{
        pin.pinColor = MKPinAnnotationColorRed;
    }
    
    
    return pin;
    
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