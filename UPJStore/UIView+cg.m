//
//  UIView+cg.m
//  UPJStore
//
//  Created by upj on 16/3/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "UIView+cg.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UIView (cg)
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
    
    for (int i = 0 ; i< arr.count+1 ;i++) {
        
        if (i == arr.count) {
            str = [NSString stringWithFormat:@"%@&key=%@",str,appsecret];
        }
        else
        {
            if (str.length >0) {
                
                str = [NSString stringWithFormat:@"%@&%@=%@",str,arr[i],[dic valueForKey:arr[i]]];
                
            }
            else
                str = [NSString stringWithFormat:@"%@=%@",arr[i],[dic valueForKey:arr[i]]];
            
        }
    }
    
    NSString *tokenStr = [self md5:str];
    
    NSMutableDictionary * Ndic = [NSMutableDictionary dictionaryWithObject:tokenStr forKey:@"token"];
    [Ndic addEntriesFromDictionary:dic];
    return Ndic;
}

@end
