//
//  CateroyModel.h
//  UPJStore
//
//  Created by upj on 16/7/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property(nonatomic,strong)NSString* cateid;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* parentid;
@property(nonatomic,strong)NSString* thumb;

@end
