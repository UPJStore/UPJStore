//
//  RecommandModelNSObject.h
//
//  Created by upj  on 16/6/22
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RecommandModelNSObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *pcate;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *productprice;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *sales;
@property (nonatomic, strong) NSString *marketprice;
@property (nonatomic, strong) NSString *thumb;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
