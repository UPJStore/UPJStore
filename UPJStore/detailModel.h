//
//  detailModel.h
//  UPJStore
//
//  Created by upj on 16/3/30.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "appraiseModel.h"
@interface detailModel : NSObject

@property (nonatomic,strong) NSString *DetailID ,*title, *content,* marketprice,*thumb,* productprice,*detailDescription,*total,*img;
@property (nonatomic,strong) NSArray *appraise;
@property (nonatomic,assign) NSInteger dispatch;
@property (nonatomic,strong) NSArray * thumb_url;

@end
