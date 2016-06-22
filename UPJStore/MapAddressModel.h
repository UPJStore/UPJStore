//
//  MapAddressModel.h
//  UPJStore
//
//  Created by upj on 16/3/28.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapAddressModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,assign) double metres;

@end
