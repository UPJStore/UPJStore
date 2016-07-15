//
//  AddressTableViewCell.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "UIView+cg.h"

@implementation AddressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        
        self.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        self.addressView = [[UIView alloc]initWithFrame:CGRectMake1(13, 13, 394, 97)];
        self.addressView.backgroundColor = [UIColor whiteColor];
        [self.addressView.layer setCornerRadius:10];
        [self addSubview:self.addressView];
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(13, 10, 162, 20)];
        self.nameLabel.textAlignment = 0;
        self.nameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self.addressView addSubview:self.nameLabel];
        self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake1(252, 10, 132, 20)];
        self.phoneLabel.textAlignment = 2;
        self.phoneLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self.addressView addSubview:self.phoneLabel];
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake1(13, 30,374, 60)];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        self.addressLabel.textColor = fontcolor;
     
        [self.addressView addSubview:self.addressLabel];
        
        
        self.button  = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake1(25, 125, 20, 20);
        [self.button addTarget:self action:@selector(isdefaultAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
    
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake1(50, 129, 80, 12)];
        label.text = @"默认地址";
        label.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:label];
        
        self.editButton = [[UIButton alloc]initWithFrame:CGRectMake1(260, 125, 63, 24)];
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editButton setTitleColor:fontcolor forState:UIControlStateNormal];
        [self.editButton.layer setBorderWidth:0.5];
        [self.editButton.layer setCornerRadius:3];
        [self.editButton.layer setBorderColor:fontcolor.CGColor];
        [self.editButton addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.editButton.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:self.editButton];
        
        self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake1(340, 125, 63, 24)];
        [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:fontcolor forState:UIControlStateNormal];
        [self.deleteButton.layer setBorderWidth:0.5];
        [self.deleteButton.layer setCornerRadius:3];
        [self.deleteButton.layer setBorderColor:fontcolor.CGColor];
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self.deleteButton addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
        
        UIView *otherView = [[UIView alloc]initWithFrame:CGRectMake1(0, 160, 414, 0.5)];
        otherView.backgroundColor = [UIColor colorFromHexRGB:@"999999"];
        [self addSubview:otherView];
    }
    return self;
}

-(void)isdefaultAction:(UIButton*)btn
{
    NSDictionary *dic = @{@"appkey":APPkey,@"mid":self.mid,@"aid":self.aid};
    [self postDataWith:dic];
}

-(void)postDataWith:(NSDictionary*)dic
{
    NSDictionary * Ndic = [self md5DicWith:dic];
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST: kSetDefault parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        
        [self.delegate reflash];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}


-(void)editBtnAction:(UIButton*)btn
{
    [self.delegate editBtnActionWithAid:_aid WithName:self.nameLabel.text WithPhone:self.phoneLabel.text WithIdCard:_idcardStr WithProvince: _provinceStr WithCity:_cityStr WithArea:_areaStr Withfulladdress:_fullAddressStr];
}

-(void)deleteBtnAction
{
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic =@{@"appkey":APPkey,@"aid":_aid,@"mid":_mid};
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    NSDictionary * Ndic =[self md5DicWith:dic];

    [manager POST:kRemove parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        
//        DLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
       [self.delegate reflash];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
