//
//  HeardView.h
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShoppingCartViewController.h"

typedef void (^clickBlock)(UIButton *);

@interface HeardView : UIView

@property (nonatomic,copy) clickBlock blockBT;

-(instancetype)initWithFrame:(CGRect)frame section:(NSInteger)sectioon carDataArrList:(NSMutableArray* )carDataArrList block:(void(^)(UIButton*))blockbt;


@end
