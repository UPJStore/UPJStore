//
//  ChangeCountView.h
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeCountView : UIView
//加
@property (nonatomic, strong) UIButton *addButton;
//减
@property (nonatomic, strong) UIButton *subButton;
//数字按钮
@property (nonatomic, strong) UITextField  *numberFD;
//已选数
@property (nonatomic, assign) NSInteger choosedCount;
//总数
@property (nonatomic, assign) NSInteger totalCount;

- (instancetype)initWithFrame:(CGRect)frame chooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount;
@end
