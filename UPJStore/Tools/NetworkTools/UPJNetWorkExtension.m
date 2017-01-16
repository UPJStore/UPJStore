//
//  UPJNetWorkExtension.m
//  UPJStore
//
//  Created by upj on 17/1/14.
//  Copyright © 2017年 UPJApp. All rights reserved.
//

#import "UPJNetWorkExtension.h"
@implementation UPJNetWorkExtension

+(id)shareInstance
{
    static UPJNetWorkExtension *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance==nil) {
            _instance = [[self alloc] init];
        }

    });
    return _instance;
}

+(AFHTTPSessionManager *)getTheIndexDatasWithParams:(NSDictionary *)params results:(resultsBlock) results
{
    AFHTTPSessionManager * manager = [self shareInstance];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:@"" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        results(results);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        results(error);

        
    }];
    
    return manager;
    
}
@end
