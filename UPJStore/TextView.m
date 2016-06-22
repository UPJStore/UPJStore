//
//  TextView.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/30.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "TextView.h"
#import "UIView+cg.h"
#import "AppDelegate.h"

@implementation TextView
{
    UILabel *label1;
    UILabel *label2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame isquestion:(BOOL)isquestion str:(NSString*)str
{
    self = [super initWithFrame:frame];
    if (self) {
        
        label1 = [[UILabel alloc]initWithFrame:CGRectMake1(20, 0, 30, 20)];
        label1.textColor = [UIColor blackColor];
        label1.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        [self addSubview:label1];
        
        label2 = [[UILabel alloc]init];
        label2.textColor =  [UIColor blackColor];
        label2.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        label2.numberOfLines = 0;
        label2.text = str;
        [self addSubview:label2];
        
        if (isquestion)
        {
            label1.text = @"Q:";
            label2.frame = CGRectMake1(40, 0, 354, 20);
        }else
        {
            label1.text = @"A:";
            label2.frame = CGRectMake1(40, 0, 354,40);
        }
    }
    return self;
}

@end
