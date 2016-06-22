//
//  AddressModel.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/25.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_aid forKey:@"aid"];
    [aCoder encodeObject:_realname forKey:@"realname"];
    [aCoder encodeObject:_idcard forKey:@"idcard"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_province forKey:@"province"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_area forKey:@"area"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_isdefault forKey:@"isdefault"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _aid = [aDecoder decodeObjectForKey:@"aid"];
        _realname = [aDecoder decodeObjectForKey:@"realname"];
        _idcard = [aDecoder decodeObjectForKey:@"idcard"];
        _mobile = [aDecoder decodeObjectForKey:@"mobile"];
        _province = [aDecoder decodeObjectForKey:@"province"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _area = [aDecoder decodeObjectForKey:@"area"];
        _address = [aDecoder decodeObjectForKey:@"address"];
        _isdefault = [aDecoder decodeObjectForKey:@"isdefault"];
    }
    return self;
}


@end
