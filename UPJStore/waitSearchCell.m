//
//  waitSearchCell.m
//  UPJStore
//
//  Created by upj on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "waitSearchCell.h"
#import "UIColor+HexRGB.h"
#import "UIView+cg.h"
#define kSWidth


@implementation waitSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return  self;
}

-(CGFloat)addBtnWithArr:(NSMutableArray *)arr
{
    
    CGFloat minSpace = 10;
    CGFloat w = 0;
    CGFloat h = 10;
    NSInteger count = 0;
    UIButton *btn;
    
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    for (NSString * str in arr) {
        CGFloat length = [str boundingRectWithSize:CGSizeMake1(414, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [[UIColor colorFromHexRGB:@"999999"]CGColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:str forState:UIControlStateNormal];
        NSInteger i = -arc4random()%2;
        if (i==1) {
            [btn setTitleColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] forState:UIControlStateNormal];
            btn.layer.borderColor =[[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1]CGColor];
        }
        
        btn.frame = CGRectMake(minSpace + w, h, length+15, 30);
        count++;
        if (minSpace + w + length + 15 > self.contentView.frame.size.width) {
            w = 0;
            h = h + btn.frame.size.height+minSpace;
            btn.frame = CGRectMake(minSpace + w, h , length+15, 30);
            count = 0;
        }
        w = btn.frame.size.width + btn.frame.origin.x;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth = 1.0;
        btn.layer.cornerRadius = 5;
        [self.contentView addSubview:btn];
    }
    return  h + btn.frame.size.height +10;
}

-(void)btnAction:(UIButton *)btn
{
    [self.delegate SearchBtnAction:btn];
}

@end
