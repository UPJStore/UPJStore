//
//  UIViewController+CG.m
//  UPJStore
//
//  Created by upj on 16/3/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "UIViewController+CG.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation UIViewController (CG)


-(AFHTTPSessionManager *)sharedManager
{
    
    return [AppDelegate sharedManager];
    
}
-(NSData*)returnImageData
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"imagedata"];
}

-(void)setImagedatawithImagedata:(NSData*)data
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:data forKey:@"imagedata"];
}


-(NSString*)returnMid
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"mid"];
}

-(void)setMidwithMid:(NSString* )mid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:mid forKey:@"mid"];
}

-(NSString*)returnNickName
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"name"];
}

-(void)setNamewithNickName:(NSString*)nickname
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nickname forKey:@"name"];
}

-(NSString*)returnRealName
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"realname"];
}

-(void)setNamewithRealName:(NSString*)realname
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:realname forKey:@"realname"];
}

-(NSString*)returnIdCard
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"idcard"];
}

-(void)setIdCardwithIdCard:(NSString* )idcard
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:idcard forKey:@"idcard"];
}

-(NSString*)returnPhoneNumber
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"phonenumber"];
}

-(void)setPhoneNumberwithPhoneNumber:(NSString* )phonenumber
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:phonenumber forKey:@"phonenumber"];
}

-(NSString*)returnImage
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"image"];
}

-(void)setImagewithImage:(NSString*)image
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:image forKey:@"image"];
}

-(NSArray*)returnAddress
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"address"];
}

-(void)setAddresswithAddress:(NSArray*)address
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:address forKey:@"address"];
}

-(NSArray*)returnCollect
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"collect"];
}

-(void)setCollectwithCollect:(NSArray*)collect
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:collect forKey:@"collect"];
}

-(NSArray*)returnAttention
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"attention"];
}

-(void)setAttentionwithAttention:(NSArray*)attention
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:attention forKey:@"attention"];
}

-(BOOL)returnIsLogin
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"islogin"];
}

-(void)setIsLoginwithIsLogin:(BOOL)isLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isLogin forKey:@"islogin"];
}

-(BOOL)returnIsAgent
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"isagent"];
}

-(void)setIsAgentwithIsAgent:(BOOL)isAgent
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isAgent forKey:@"isagent"];
}

-(NSString *)md5:(NSString *)str {
    
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
    
//    DLog(@"str = %@",str);
    
    NSString *tokenStr = [self md5:str];
    
    NSMutableDictionary * Ndic = [NSMutableDictionary dictionaryWithObject:tokenStr forKey:@"token"];
    [Ndic addEntriesFromDictionary:dic];
    return Ndic;
}

-(NSArray*)returnCoupon
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"conpon"];
}

-(void)setConponwithConpon:(NSArray*)conpon
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:conpon forKey:@"conpon"];
}


static const void *isShowTabKey = &isShowTabKey;

@dynamic isShowTab;

-(BOOL)isShowTab
{
    return objc_getAssociatedObject(self, isShowTabKey);
}

-(void)setIsShowTab:(BOOL)isShowTab
{
    objc_setAssociatedObject(self, isShowTabKey, [NSNumber numberWithBool:isShowTab], OBJC_ASSOCIATION_ASSIGN);
    
}

-(BOOL)hideTabBarWithTabState:(BOOL) tabBarIsShow {
    if (!tabBarIsShow)
    {
        
    }
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect tabFrame = self.tabBarController.tabBar.frame;
                         NSLog(@"MinY %.f",CGRectGetMinY(tabFrame));
                         NSLog(@"GetHeight %.f",CGRectGetHeight(tabFrame));
                         NSLog(@"origin.y %.f",tabFrame.origin.y);

                         if (tabFrame.origin.y < kHeight) {
                             tabFrame.origin.y = tabFrame.size.height + CGRectGetMinY(tabFrame);
                         }
                         self.tabBarController.tabBar.frame = tabFrame;
                     }];
    return NO;
}

- (BOOL)showTabBarWithTabState:(BOOL) tabBarIsShow {
    if (tabBarIsShow)
    {
        
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect tabFrame = self.tabBarController.tabBar.frame;
                         NSLog(@"MinY %.f",CGRectGetMinY(tabFrame));
                         NSLog(@"GetHeight %.f",CGRectGetHeight(tabFrame));
                         NSLog(@"origin.y %.f",tabFrame.origin.y);
                         
                         if (tabFrame.origin.y >= kHeight)
                         {
                             tabFrame.origin.y = CGRectGetHeight(tabFrame) - CGRectGetMinY(tabFrame);
                             
                         }
                         
                         if (tabFrame.origin.y < 0) {
                             tabFrame.origin.y = -tabFrame.origin.y;
                         }
                         
                         if (tabFrame.origin.y > kHeight) {
                             tabFrame.origin.y = kHeight;
                         }


                         self.tabBarController.tabBar.frame = tabFrame;
                     }];
    return YES;
}


#pragma 加载动画属性

static const void * loadingHudKey = &loadingHudKey;

@dynamic loadingHud;

-(MBProgressHUD *)loadingHud
{
    return  objc_getAssociatedObject(self, loadingHudKey);
}

-(void)setLoadingHud:(MBProgressHUD *)loadingHud
{
    objc_setAssociatedObject(self, loadingHudKey, loadingHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



#pragma mark -- 加载动画
-(void)setMBHUD{
    self.loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the custom view mode to show any view.
    /*
     self.loadingHud.mode = MBProgressHUDModeCustomView;
     UIImage *gif = [UIImage sd_animatedGIFNamed:@"youpinji"];
     
     UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
     self.loadingHud.customView = gifView;
     */
//    self.loadingHud.bezelView.backgroundColor = [UIColor clearColor];
//    self.loadingHud.animationType = MBProgressHUDAnimationFade;
//    self.loadingHud.backgroundColor = [UIColor whiteColor];
}


@end
