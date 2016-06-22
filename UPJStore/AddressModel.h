//
//  AddressModel.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/25.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject<NSCoding>

@property(nonatomic,strong)NSString *aid;

@property(nonatomic,strong)NSString *realname;

@property(nonatomic,strong)NSString *idcard;

@property(nonatomic,strong)NSString *mobile;

@property(nonatomic,strong)NSString *province;

@property(nonatomic,strong)NSString *city;

@property(nonatomic,strong)NSString *area;

@property(nonatomic,strong)NSString *address;

@property(nonatomic,strong)NSString *isdefault;

@end
