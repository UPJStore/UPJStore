//
//  GoodsViewController.h
//  UPJStore
//
//  Created by upj on 16/3/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsViewController : UIViewController

@property (nonatomic,strong)NSString *pid;
@property (nonatomic,strong)UIImage *headerImg;
@property (nonatomic,strong)NSString *introduce;
@property (nonatomic,assign) BOOL isFromSort;

@end
