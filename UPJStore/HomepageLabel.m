//
//  HomepageLabel.m
//  UPJStore
//
//  Created by upj on 16/7/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "HomepageLabel.h"
#import "UIViewController+CG.h"

@implementation HomepageLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Drawing code
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 50, 25);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 150, 25);
    
    CGContextMoveToPoint(context, 264, 25);
    
    CGContextAddLineToPoint(context, 364, 25);

   
    //连接上面定义的坐标点，也就是开始绘图
    CGContextStrokePath(context);
    [self addtext];
}

-(void)addtext
{
    self.textAlignment = 1;
    self.numberOfLines = 0;
    self.textColor = [UIColor blackColor];
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:@"海外热活好货\nHot product"];
    [attributeString1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(14)]} range:NSMakeRange(0, 6)];
    [attributeString1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(8)]} range:NSMakeRange(6,12)];
    self.attributedText = attributeString1;
}

@end
