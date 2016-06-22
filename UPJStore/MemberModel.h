//
//  MemberModel.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject
//头像
@property(nonatomic,strong)NSString *avatar;
//上级的id
@property(nonatomic,strong)NSString *shareid;
//公众号id
@property(nonatomic,strong)NSString *weid;
//银行卡号
@property(nonatomic,strong)NSString *bankcard;
//银行名称
@property(nonatomic,strong)NSString *banktype;
//支付宝号
@property(nonatomic,strong)NSString *alipay;
//微信号
@property(nonatomic,strong)NSString *wxhao;
//已结佣金
@property(nonatomic,strong)NSString *commission;
//已打款佣金
@property(nonatomic,strong)NSString *zhifu;
//创建时间
@property(nonatomic,strong)NSString *createtime;
//成为创客的时间
@property(nonatomic,strong)NSString *flagtime;
//状态
@property(nonatomic,strong)NSString *status;
//身份
@property(nonatomic,strong)NSString *flag;
//点击数
@property(nonatomic,strong)NSString *clickcount;
//余额
@property(nonatomic,strong)NSString *credit2;
//用户的代理等级
@property(nonatomic,strong)NSString *member_agent_id;
//身份证号
@property(nonatomic,strong)NSString *idcard;
//区域id
@property(nonatomic,strong)NSString *region_id;
//所在公司
@property(nonatomic,strong)NSString *company;
//所绑定的店铺的id
@property(nonatomic,strong)NSString *bind_shop;

@property(nonatomic,strong)NSString *pwd;

@property(nonatomic,strong)NSString *from_user;

@property(nonatomic,strong)NSString *mid;

@property(nonatomic,strong)NSString *realname;

@property(nonatomic,strong)NSString *nickname;

@property(nonatomic,strong)NSString *mobile;

@end
