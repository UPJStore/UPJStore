//
//  UIViewController+CG.h
//  UPJStore
//
//  Created by upj on 16/3/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"


CG_INLINE CGSize
CGSizeMake1(CGFloat width, CGFloat height)
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    CGSize size;
    size.width = width * app.autoSizeScaleX;
    size.height = height * app.autoSizeScaleY;
    return size;
}

CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    //先得到appdelegate
    AppDelegate *app= [UIApplication sharedApplication].delegate;
    CGRect rect;
    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
    rect.origin.x = x*app.autoSizeScaleX;//原点的X坐标的改变
    rect.origin.y = y*app.autoSizeScaleY;//原点的Y坐标的改变
    rect.size.width = width*app.autoSizeScaleX;//宽的改变
    rect.size.height = height*app.autoSizeScaleY;//高的改变
    return rect;
}

CG_INLINE CGPoint
CGPointMake1(CGFloat x, CGFloat y)
{
    //先得到appdelegate
    AppDelegate *app= [UIApplication sharedApplication].delegate;
    CGPoint point;
    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
    point.x = x*app.autoSizeScaleX;//原点的X坐标的改变
    point.y = y*app.autoSizeScaleY;//原点的Y坐标的改变
        return point;
}

CG_INLINE CGFloat
CGFloatMakeX (CGFloat x)
{
    //先得到appdelegate
    AppDelegate *app= [UIApplication sharedApplication].delegate;
    CGFloat xFloat;
    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
    xFloat = x*app.autoSizeScaleX;//原点的X坐标的改变
    return xFloat;
}

CG_INLINE CGFloat
CGFloatMakeY (CGFloat y)
{
    //先得到appdelegate
    AppDelegate *app= [UIApplication sharedApplication].delegate;
    CGFloat yFloat;
    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
    yFloat = y*app.autoSizeScaleY;//原点的X坐标的改变
    return yFloat;
}

CG_INLINE CGRect
CGRectMakeCode(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
    
    CGRect rect;
    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
    rect.origin.x = x;//原点的X坐标的改变
    rect.origin.y = y-64;//原点的Y坐标的改变
    rect.size.width = width;//宽的改变
    rect.size.height = height;//高的改变
    return rect;
}

@interface UIViewController (CG)

@property (nonatomic,assign) BOOL isShowTab;
@property (nonatomic,strong)MBProgressHUD *loadingHud;


-(AFHTTPSessionManager *)sharedManager;

-(NSData*)returnImageData;

-(void)setImagedatawithImagedata:(NSData*)data;

-(NSString *)returnMid;

-(void)setMidwithMid:(NSString* )mid;

-(NSString*)returnNickName;

-(void)setNamewithNickName:(NSString*)nickname;

-(NSString*)returnRealName;

-(void)setNamewithRealName:(NSString*)realname;

-(NSString*)returnIdCard;

-(void)setIdCardwithIdCard:(NSString* )idcard;

-(NSString*)returnPhoneNumber;

-(void)setPhoneNumberwithPhoneNumber:(NSString* )phonenumber;

-(NSString*)returnImage;

-(void)setImagewithImage:(NSString*)image;

-(NSArray*)returnAddress;

-(void)setAddresswithAddress:(NSArray*)address;

-(NSArray*)returnCollect;

-(void)setCollectwithCollect:(NSArray*)collect;

-(NSArray*)returnAttention;

-(void)setAttentionwithAttention:(NSArray*)attention;

-(BOOL)returnIsLogin;

-(void)setIsLoginwithIsLogin:(BOOL)isLogin;
//是否为代理商
-(BOOL)returnIsAgent;

-(void)setIsAgentwithIsAgent:(BOOL)isAgent;
//是否为经销商
-(BOOL)returnIsDealer;

-(void)setIsDealerwithIsDealer:(BOOL)isDealer;
//是否为创客
-(BOOL)returnIsFlag;

-(void)setIsFlagwithIsFlag:(BOOL)isFlag;

-(NSString*)returnOpenId;

-(void)setOpenIdwithOpenId:(NSString*)Openid;

-(NSString *)md5:(NSString *)str;

-(NSDictionary *)md5DicWith:(NSDictionary *)dic;

-(NSArray*)returnCoupon;

-(void)setConponwithConpon:(NSArray*)conpon;

-(BOOL)hideTabBarWithTabState:(BOOL) tabBarIsShow;

-(BOOL)showTabBarWithTabState:(BOOL) tabBarIsShow;

-(BOOL)returnIsFromHomePage;

-(void)setIsFromHomePagewithIsFromHomePage:(BOOL)isFromHomePage;

#pragma mark -- 网络错误提示


#pragma mark -- 加载动画
-(void)setMBHUD;

-(void)setMBHUD2Withtext:(NSString*)str;

@end
