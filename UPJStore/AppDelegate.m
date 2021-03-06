//
//  AppDelegate.m
//  UPJStore
//
//  Created by 张靖佺 on 16/2/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SearchAndSortViewController.h"
#import "ShoppingCartViewController.h"
#import "MemberCenterViewController.h"
#import "AFNetWorking.h"
#import "LoginViewController.h"
#import "UIViewController+CG.h"
#import "StartViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "RealReachability.h"
#import "AdvertiseView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Bugly/Bugly.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define kWXAPP_ID @"wx50a2b6dce88256c3"
#define kWXAPP_SECRET @"b8e8be66e271b4083f4ee29c7a59f20b"

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>
{
    NSDictionary *jsonDic;
    UIAlertController *alertCon;
    NSString *errcode;
    MemberModel *model;
    //    UITabBarController* tabController ;
    UITextField *phoneNum;
    UITextField *password;
    BOOL isFirst;
    NSString * force_upgrade;
    NSInteger inAppCount;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //腾讯bugly
    [Bugly startWithAppId:@"900044501"];
    // Override point for customization after application launch.
    
    // Required
    // notice: 3.0.0及以后版本注册可以这样写,也可以继续 旧的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使 IDFA功能请添加此代码并在初始化 法的advertisingIdentifier参数中填写对应值 NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册 法,改成可上报IDFA,如果没有使 IDFA直接传nil
    // 如需继续使 pushConfig.plist 件声明appKey等配置内容,请依旧使 [JPUSHService setupWithOption:launchOptions] 式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"5798de4b638c4e2d3694fe7e" channel:@"App Store" apsForProduction:YES advertisingIdentifier:nil];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.autoSizeScaleX = kWidth/414;
    self.autoSizeScaleY = kHeight/736;
    //    DLog(@"--X=%f",self.autoSizeScaleX);
    //    DLog(@"--Y=%f",self.autoSizeScaleY);
    
    
    [self showView];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"inAppCount"] ==nil) {
        inAppCount = 0;
    }else
    {   inAppCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppCount"] integerValue];
    }
    
    
    return YES;
}


#pragma  she
-(void)showAdv
{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
        
    }
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
    
    
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    // TODO 请求广告接口
    
    NSArray *imageArray = @[@"http://m.upinkji.com/static/app/images/app_function_ad.jpg"];
    NSString *imageUrl = imageArray.lastObject;
    
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }
    
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}

-(void)onResp:(BaseReq *)resp{
    
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    
    if (aresp.errCode == 0) {
        if([resp isKindOfClass:[PayResp class]]){
            //支付返回结果，实际支付结果需要去微信服务器端查询
            DLog(@"+++++++++支付结果++++++++");
            
            DLog(@"resp.errCode = %d  errStr = %@",aresp.errCode,aresp.errStr);
            switch (aresp.errCode) {
                case WXSuccess:
                    DLog(@"支付成功－PaySuccess，retcode = %d", aresp.errCode);
                    [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:@"成功"];
                    break;
                    
                default:
                    DLog(@"错误，retcode = %d, retstr = %@", aresp.errCode,aresp.errStr);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
                    
                    break;
                    
            }
            
            
        }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
            DLog(@"success!");
        }else{
            
            _wxCode = aresp.code;
            NSDictionary *dic = @{@"wechat_code":_wxCode,@"appkey":APPkey};
            DLog(@"%@",dic);
            
            [self getAccess_token];
        }
    }else{
        
        DLog(@"错误，retcode = %d, retstr = %@", aresp.errCode,aresp.errStr);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
    }
}

-(void)getAccess_token{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,self.wxCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.access_token = [dic objectForKey:@"access_token"];
                self.openid = [dic objectForKey:@"openid"];
                self.unionid = [dic objectForKey:@"unionid"];
                
                [self getUserInfo];
            }
        });
    });
    
}
-(void)getUserInfo{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    [self.window.rootViewController setMBHUD];
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token,self.openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                DLog(@"openid = %@", [dic objectForKey:@"openid"]);
                DLog(@"nickname = %@", [dic objectForKey:@"nickname"]);
                DLog(@"sex = %@", [dic objectForKey:@"sex"]);
                DLog(@"country = %@", [dic objectForKey:@"country"]);
                DLog(@"province = %@", [dic objectForKey:@"province"]);
                DLog(@"city = %@", [dic objectForKey:@"city"]);
                DLog(@"headimgurl = %@", [dic objectForKey:@"headimgurl"]);
                DLog(@"unionid = %@", [dic objectForKey:@"unionid"]);
                DLog(@"privilege = %@", [dic objectForKey:@"privilege"]);
                
#pragma mark - 传openid给后台验证
                NSDictionary *dic0 = @{@"app_wechat_openid":self.openid,@"appkey":APPkey,@"unionid":self.unionid};
                DLog(@"%@",dic0);
                AFHTTPSessionManager *manager = [AppDelegate sharedManager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
                
                //传入的参数
                NSDictionary * Ndic = [self md5DicWith:dic0];
                
                [manager POST:kOther parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    // DLog(@"%@",responseObject);
                    [self.window.rootViewController.loadingHud hideAnimated:YES];
                    self.window.rootViewController.loadingHud =nil;
                    NSNumber *number = [responseObject valueForKey:@"errcode"];
                    errcode = [NSString stringWithFormat:@"%@",number];
                    //未绑定账号
                    if ([errcode isEqualToString:@"0"]&& [responseObject[@"data"] isEqual:[NSNull null]])
                    {
                        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        appdelegate.headimgurl = [dic objectForKey:@"headimgurl"]; // 传递头像地址
                        appdelegate.nickname = [dic objectForKey:@"nickname"]; // 传递昵称
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Note1" object:nil]; // 发送通知
                        
                    }
                    // 已绑定账号
                    else if([errcode isEqualToString:@"0"]&& ![responseObject[@"data"] isEqual:[NSNull null]]){
                        jsonDic = [responseObject valueForKey:@"data"];
                        model = [MemberModel new];
                        [model setValuesForKeysWithDictionary:jsonDic];
                        [self.delegate loginFinishWithmodel:model];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Note2" object:nil]; // 发送通知
                    }
                    // 错误信息
                    else
                    {
                        NSString *str1 = [responseObject valueForKey:@"errmsg"];
                        
                        alertCon = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                        [alertCon addAction:okAction];
                        [self.window.rootViewController presentViewController:alertCon animated:YES completion:nil];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                 {
                     DLog(@"failure%@",error);
                 }];
                
                
            }
        });
        
    });
}

-(void)dismissAVC:(NSTimer*)timer
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(NSString *)md5:(NSString *)str
{
    
    const char* cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

-(NSDictionary *)md5DicWith:(NSDictionary *)dic
{
    NSString *str = @"";
    NSArray * arr =[dic allKeys];
    NSArray *newArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    //    DLog(@"new array = %@",newArray);
    
    for (int i = 0 ; i< newArray.count+1 ;i++) {
        
        if (i == arr.count) {
            str = [NSString stringWithFormat:@"%@&key=%@",str,appsecret];
        }
        else
        {
            if (str.length >0) {
                
                str = [NSString stringWithFormat:@"%@&%@=%@",str,newArray[i],[dic valueForKey:newArray[i]]];
                
            }
            else
                str = [NSString stringWithFormat:@"%@=%@",newArray[i],[dic valueForKey:newArray[i]]];
            
        }
    }
    
    // DLog(@"str = %@",str);
    
    NSString *tokenStr = [self md5:str];
    
    NSMutableDictionary * Ndic = [NSMutableDictionary dictionaryWithObject:tokenStr forKey:@"token"];
    [Ndic addEntriesFromDictionary:dic];
    return Ndic;
}

#pragma mark - 账号密码文本框

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    
    self.window.rootViewController.tabBarController.selectedIndex = 4;
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            DLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            DLog(@"result = %@",resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            DLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            DLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (void)networkChanged:(NSNotification *)notification
{
    if (isFirst == YES) {
        isFirst = NO;
    }
    else
    {
        [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
            switch (status)
            {
                case RealStatusNotReachable:
                {
                    break;
                }
                    
                case RealStatusViaWiFi:
                {
                    
                    alertCon = [UIAlertController alertControllerWithTitle:nil message:@"WiFi链接状态。" preferredStyle:UIAlertControllerStyleAlert];
                    [self.window.rootViewController presentViewController:alertCon animated:YES completion:nil];
                    
                    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows animated:YES];
                    
                    hub.label.text = @"wifi链接状态";
                    hub.mode = MBProgressHUDModeText;
                    hub.removeFromSuperViewOnHide = YES;
                    [hub hideAnimated:YES afterDelay:0.7];
                
                    break;
                }
                    
                case RealStatusViaWWAN:
                {    alertCon = [UIAlertController alertControllerWithTitle:nil message:@"您现在在使用移动网络数据，注意您的流量耗损"preferredStyle:UIAlertControllerStyleAlert];
                    [self.window.rootViewController presentViewController:alertCon animated:YES completion:nil];
                    
                    //                [[[UIAlertView alloc] initWithTitle:@"网络状态" message:@"您现在在使用移动网络数据，注意您的流量耗损" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil] show];
                    
                }}}];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAVC:) userInfo:nil repeats:NO];
    }
}


-(void)VersionBUtton
{
    
    AFHTTPSessionManager *manager = [AppDelegate sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [manager GET:@"https://itunes.apple.com/lookup?id=1104253189" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
#pragma 获取数据json化。
         NSDictionary * dic;
         if ([responseObject isKindOfClass:[NSData class]]) {
             dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             
         }else    dic = responseObject;
         
         NSArray * verarr = dic[@"results"];
         //做出判断，看有没有下架。假如紧急下架了，就不会运行这个位置，以防崩溃。
         if (verarr.count != 0) {
             NSDictionary * dic2 =verarr[0];
             NSString *verStr = dic2[@"version"];
             
             NSDictionary * Versiondic = @{@"appkey":APPkey};
             NSDictionary * Ndic = [self md5DicWith:Versiondic];
             [manager POST:kAllVersion parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 NSString * nowVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"];
                 
                 NSInteger i = 0;
                 NSArray * arr;
                 if ([responseObject isKindOfClass:[NSData class]]) {
                     arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                     
                 }else    arr = responseObject;
                 
                 for (NSDictionary * dic  in arr)
                 {
                     if ([dic[@"version"] isEqualToString:nowVersion]) {
                         
                         force_upgrade = dic[@"force_upgrade"];
                         DLog(@"%@",force_upgrade);
                     }
                     else
                         i++;
                 }
                 
                 [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkAppUpdate:) userInfo:verStr repeats:NO];
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
             }];
             
         }
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
    
}

-(void)checkAppUpdate:(NSTimer * )timer
{
    NSString * nowVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"];
    DLog(@"新版本 ： %@ ，当前版本 %@ ",[timer userInfo],nowVersion);
    float newVersionF = [[timer userInfo] floatValue]*100;
    float nowVersionF = [nowVersion floatValue]*100;
    NSArray *NewArr = [self getOnlyNum:[timer userInfo]];
    NSArray *NowArr = [self getOnlyNum:nowVersion];
    
    if (NewArr.count == 3)
    {
        int SVersion = [NewArr[2] intValue];
        newVersionF = (newVersionF + SVersion);
    }
    
    if (NowArr.count == 3)
    {
        int SVersion = [NowArr[2] intValue];
        nowVersionF = (nowVersionF + SVersion);
    }
    
    if (newVersionF > nowVersionF && inAppCount == 0 )
    {
        
        DLog(@"新版本 ： %@ ，当前版本 %@ ",[timer userInfo],nowVersion);
        
        UIAlertController * alVC = [UIAlertController alertControllerWithTitle:@"" message:@"有可更新版本" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * okaction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSString * strr = @"https://itunes.apple.com/us/app/you-pin-ji-quan-qiu-gou/id1104253189?l=zh&ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strr]];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            if ([force_upgrade boolValue] == 1)
                                            {
                                                [self exitApplication];
                                            }
                                            
                                        }];
        
        [alVC addAction:okaction];
        [alVC addAction:cancelAction];
        [self.window.rootViewController presentViewController:alVC animated:YES completion:^{
            
        }];
    }
    inAppCount++;
    
    if (inAppCount >2) {
        inAppCount = 0;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:inAppCount] forKey:@"inAppCount"];
    
}

-(void)showView
{
    
    UITabBarController* tabController = [[UITabBarController alloc]init];
    
    ViewController * homePageVC = [[ViewController alloc]init];
    SearchAndSortViewController *searchAndSortVC = [[SearchAndSortViewController alloc]init];
    //    MemberCenterViewController * memberVC = [[MemberCenterViewController alloc]init];
    //    ShareViewController *shareVC = [[ShareViewController alloc]init];
    UINavigationController *HPNAVI = [[UINavigationController alloc]initWithRootViewController:homePageVC];
    UINavigationController *SSNAVI = [[UINavigationController alloc]initWithRootViewController:searchAndSortVC];
    //    UINavigationController *SCNAVI = [[UINavigationController alloc]initWithRootViewController:shoppingCartVC];
    UINavigationController *SCNAVI = [[UINavigationController alloc]initWithRootViewController:[[ShoppingCartViewController alloc]init]];
    UINavigationController *MCNAVI = [[UINavigationController alloc]initWithRootViewController:[[MemberCenterViewController alloc]init]];
    //    UINavigationController *SPNAVI = [[UINavigationController alloc]initWithRootViewController:shareVC];
    
    tabController.viewControllers  =@[HPNAVI,SSNAVI,SCNAVI,MCNAVI];
    NSArray *arr = @[@"主页",@"分类",@"购物车",@"个人中心"];
    
    for (int i = 0 ; i<tabController.viewControllers.count; i++) {
        
        UITabBarItem *tabItem = [tabController.tabBar.items objectAtIndex:i];
        
        tabItem.title = arr[i];
        tabItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tabSel%d",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"tab%d",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexRGB:@"cc2245"]} forState:UIControlStateSelected];
    }
    
    
    self.window.rootViewController = tabController;
    
#pragma mark - 提示网络状态的。
    [GLobalRealReachability startNotifier];
    isFirst = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    //设置导航条样式
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:CGFloatMakeY(18)]}];
    [WXApi registerApp:@"wx50a2b6dce88256c3" withDescription:@"wechat"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user valueForKey:@"first"])
    {
        StartViewController *startVC = [[StartViewController alloc] init];
        //为user设置一个key为first的键值对
        [user setBool:YES forKey:@"first"];
        [self.window.rootViewController presentViewController:startVC animated:NO completion:nil];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(VersionBUtton) userInfo:nil repeats:NO];
    
}

- (void)exitApplication {
    
    
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}

+(AFHTTPSessionManager *)sharedManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        
    });
    
    return manager;
    
}

- (NSArray *)getOnlyNum:(NSString *)str  {
    
    NSString *onlyNumStr = [str stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [str length])];
    
    NSArray *numArr = [onlyNumStr componentsSeparatedByString:@"."];
    return numArr;
}

#pragma mark - 推送功能

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
        ]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执 这个 法,选择 是否提醒 户,有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(); // 系统要求执 这个 法
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - 系统方法

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
