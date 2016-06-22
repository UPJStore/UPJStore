//
//  Commodity.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderModel : NSObject
//订单号
@property(nonatomic,strong)NSString *ordersn;
//总价钱
@property(nonatomic,strong)NSString *goodsprice;
//电话
@property(nonatomic,strong)NSString *mobile;
//名字
@property(nonatomic,strong)NSString *consignee;
//省
@property(nonatomic,strong)NSString *province;
//市
@property(nonatomic,strong)NSString *city;
//区
@property(nonatomic,strong)NSString *area;
//地址
@property(nonatomic,strong)NSString *address;
//订单id
@property(nonatomic,strong)NSString *orderid;
//订单状态
@property(nonatomic,strong)NSString *status;
//邮费
@property(nonatomic,strong)NSString *dispatchprice;
//身份证
@property(nonatomic,strong)NSString *idcard;
//mid
@property(nonatomic,strong)NSString *mid;

@property(nonatomic,strong)NSArray *goodArr;

@property(nonatomic,strong)NSString *createtime;

@end
