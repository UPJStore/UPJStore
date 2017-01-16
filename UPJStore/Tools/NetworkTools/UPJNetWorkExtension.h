//
//  UPJNetWorkExtension.h
//  UPJStore
//
//  Created by upj on 17/1/14.
//  Copyright © 2017年 UPJApp. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef void(^resultsBlock)(id resultsObj);
@interface UPJNetWorkExtension : AFHTTPSessionManager


+(AFHTTPSessionManager *)getTheIndexDatasWithParams:(NSDictionary *)params results:(resultsBlock) results;

@end
