//
//  AddressTableViewCell.h
//  UPJStore
//
//  Created by 邝健锋 on 16/3/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol editbtnAction;

@interface AddressTableViewCell : UITableViewCell

@property(nonatomic,strong)NSString *mid;

@property(nonatomic,strong)NSString *aid;

@property(nonatomic,strong)UIView *addressView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *phoneLabel;

@property(nonatomic,strong)UILabel *addressLabel;

@property(nonatomic,strong)UIButton *button;

@property(nonatomic,strong)UIButton *editButton;

@property(nonatomic,strong)UIButton *deleteButton;

@property(nonatomic,strong)NSString *idcardStr;

@property(nonatomic,strong)NSString *provinceStr;

@property(nonatomic,strong)NSString *cityStr;

@property(nonatomic,strong)NSString *areaStr;

@property(nonatomic,strong)NSString *fullAddressStr;

@property(nonatomic,weak)id <editbtnAction>delegate;

@end

@protocol editbtnAction <NSObject>

-(void)editBtnActionWithAid:(NSString*)aid WithName:(NSString*)name WithPhone:(NSString*)phone WithIdCard:(NSString*)idcard WithProvince:(NSString*)province WithCity:(NSString*)city WithArea:(NSString*)area Withfulladdress:(NSString*)fulladdress;

-(void)reflash;


@end


