//
//  GoodSDetailViewController.h
//  UPJStore
//
//  Created by upj on 16/3/29.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodSDetailViewController : UIViewController

@property (nonatomic,strong) NSDictionary *goodsDic;
@property (nonatomic,assign) BOOL isCollection;
@property (nonatomic,assign) BOOL isFromHomePage;
@property (nonatomic,assign) BOOL isFromCollection;
@property (nonatomic,assign) BOOL isFromBrand;

@end
