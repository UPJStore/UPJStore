//
//  OrderBtn.m
//  UPJStore
//
//  Created by upj on 16/8/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OrderBtn.h"
#import "UIViewController+CG.h"

@implementation OrderBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //添加自身作为观察者
        
        //1.获取通知中心
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

        [notificationCenter addObserver:self selector:@selector(change:) name:@"didtap" object:nil];
        self.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        self.titleLabel.textAlignment = 1;
    }
    return self;
}

- (void)didtap
{
 
    NSNotification *tapNotification = [NSNotification notificationWithName:@"didtap" object:self userInfo:@{@"date":[NSString stringWithFormat:@"%ld",self.tag]}];
    
    //2.获取通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //3.使用通知中心发送通知
    [notificationCenter postNotification:tapNotification];
    
}

-(void)change:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSString *tag = dic[@"date"];
    if (![tag isEqualToString:[NSString stringWithFormat:@"%ld",self.tag]]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else
    {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

-(void)dealloc
{
    //移除观察者
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //一次过移除观察者对所有通知的观察
    [notificationCenter removeObserver:self];
}

@end
