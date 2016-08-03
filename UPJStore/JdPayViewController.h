//
//  JdPayViewController.h
//  UPJStore
//
//  Created by upj on 16/8/1.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol payreturn;

@interface JdPayViewController : UIViewController

@property(nonatomic,weak)id <payreturn>delegate;

@property(nonatomic,strong)NSString* urlstr;

@end

@protocol payreturn <NSObject>

-(void)paysuccess;

-(void)payfail;

@end
