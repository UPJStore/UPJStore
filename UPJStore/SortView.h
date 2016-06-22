//
//  SortView.h
//  UPJStore
//
//  Created by upj on 16/3/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortViewAction;

@interface SortView : UIView

@property (nonatomic,weak) id<SortViewAction> delegate;


-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)arr;

@end

@protocol SortViewAction <NSObject>

-(void)BtnAction:(UIButton*)btn;

@end