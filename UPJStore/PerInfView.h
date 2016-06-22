//
//  PerInfView.h
//  UPJStore
//
//  Created by 张靖佺 on 16/2/27.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PerinfViewPush;

@interface PerInfView : UIView

@property(nonatomic,strong)UIButton* integralBtn;

@property(nonatomic,strong)UIButton* collectBtn;

@property(nonatomic,strong)UIButton* concernBtn;

@property(nonatomic,strong)UILabel* integralLabel;

@property(nonatomic,strong)UILabel* collectLabel;

@property(nonatomic,strong)UILabel* concernLabel;

@property(nonatomic,weak)id <PerinfViewPush>delegate;

-(instancetype)initWithFrame:(CGRect)frame;

@end

@protocol PerinfViewPush <NSObject>

-(void)perinfViewPush:(NSInteger)number;

@end

