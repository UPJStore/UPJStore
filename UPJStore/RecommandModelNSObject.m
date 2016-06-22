//
//  RecommandModelNSObject.m
//
//  Created by upj  on 16/6/22
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "RecommandModelNSObject.h"


NSString *const kRecommandModelNSObjectPcate = @"pcate";
NSString *const kRecommandModelNSObjectId = @"id";
NSString *const kRecommandModelNSObjectProductprice = @"productprice";
NSString *const kRecommandModelNSObjectTitle = @"title";
NSString *const kRecommandModelNSObjectSales = @"sales";
NSString *const kRecommandModelNSObjectMarketprice = @"marketprice";
NSString *const kRecommandModelNSObjectThumb = @"thumb";


@interface RecommandModelNSObject ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RecommandModelNSObject

@synthesize pcate = _pcate;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize productprice = _productprice;
@synthesize title = _title;
@synthesize sales = _sales;
@synthesize marketprice = _marketprice;
@synthesize thumb = _thumb;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.pcate = [self objectOrNilForKey:kRecommandModelNSObjectPcate fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kRecommandModelNSObjectId fromDictionary:dict];
            self.productprice = [self objectOrNilForKey:kRecommandModelNSObjectProductprice fromDictionary:dict];
            self.title = [self objectOrNilForKey:kRecommandModelNSObjectTitle fromDictionary:dict];
            self.sales = [self objectOrNilForKey:kRecommandModelNSObjectSales fromDictionary:dict];
            self.marketprice = [self objectOrNilForKey:kRecommandModelNSObjectMarketprice fromDictionary:dict];
            self.thumb = [self objectOrNilForKey:kRecommandModelNSObjectThumb fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.pcate forKey:kRecommandModelNSObjectPcate];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kRecommandModelNSObjectId];
    [mutableDict setValue:self.productprice forKey:kRecommandModelNSObjectProductprice];
    [mutableDict setValue:self.title forKey:kRecommandModelNSObjectTitle];
    [mutableDict setValue:self.sales forKey:kRecommandModelNSObjectSales];
    [mutableDict setValue:self.marketprice forKey:kRecommandModelNSObjectMarketprice];
    [mutableDict setValue:self.thumb forKey:kRecommandModelNSObjectThumb];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.pcate = [aDecoder decodeObjectForKey:kRecommandModelNSObjectPcate];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kRecommandModelNSObjectId];
    self.productprice = [aDecoder decodeObjectForKey:kRecommandModelNSObjectProductprice];
    self.title = [aDecoder decodeObjectForKey:kRecommandModelNSObjectTitle];
    self.sales = [aDecoder decodeObjectForKey:kRecommandModelNSObjectSales];
    self.marketprice = [aDecoder decodeObjectForKey:kRecommandModelNSObjectMarketprice];
    self.thumb = [aDecoder decodeObjectForKey:kRecommandModelNSObjectThumb];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_pcate forKey:kRecommandModelNSObjectPcate];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kRecommandModelNSObjectId];
    [aCoder encodeObject:_productprice forKey:kRecommandModelNSObjectProductprice];
    [aCoder encodeObject:_title forKey:kRecommandModelNSObjectTitle];
    [aCoder encodeObject:_sales forKey:kRecommandModelNSObjectSales];
    [aCoder encodeObject:_marketprice forKey:kRecommandModelNSObjectMarketprice];
    [aCoder encodeObject:_thumb forKey:kRecommandModelNSObjectThumb];
}

- (id)copyWithZone:(NSZone *)zone
{
    RecommandModelNSObject *copy = [[RecommandModelNSObject alloc] init];
    
    if (copy) {

        copy.pcate = [self.pcate copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.productprice = [self.productprice copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.sales = [self.sales copyWithZone:zone];
        copy.marketprice = [self.marketprice copyWithZone:zone];
        copy.thumb = [self.thumb copyWithZone:zone];
    }
    
    return copy;
}


@end
