//
//  HeardView.m
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "HeardView.h"
@interface HeardView()

@property (nonatomic,assign) NSInteger section;
@property (nonatomic,copy) NSMutableArray *carDataArrList;

@end


@implementation HeardView
-(instancetype)initWithFrame:(CGRect)frame section:(NSInteger)section carDataArrList:(NSMutableArray *)carDataArrList block:(void (^)(UIButton *))blockbt
{
    self =[super initWithFrame:frame];
    if (self) {
        _section = section;
        _carDataArrList = carDataArrList;
        _blockBT= blockbt;
        [self initView];

    }
            return self;
}

-(void)initView
{
    UIImage *btimg = [UIImage imageNamed:@"UnSelected.png"];
    UIImage *selectImg= [UIImage imageNamed:@"Selected.png"];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(2, 5, btimg.size.width+12, btimg.size.height+10)];
    bt.tag = 100 +_section;
    [bt addTarget:self action:@selector(clickAll:) forControlEvents:UIControlEventTouchUpInside];
    [bt setImage:btimg forState:UIControlStateNormal];
    [bt setImage:selectImg forState:UIControlStateSelected];
    [self addSubview:bt];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt.frame)+15, 0, 90, 40)];
    label.textColor = [UIColor colorFromHexRGB:@"666666"];
    label.font =[UIFont systemFontOfSize:16];
    
    NSArray * list = [self.carDataArrList objectAtIndex:_section];
    
    NSMutableDictionary *dic =[list lastObject];
    
    if ([@"YES"isEqualToString:[dic objectForKey:@"checked"]]) {
        bt.selected = YES;
    }
    else if ([@"NO" isEqualToString:[dic objectForKey:@"checked"]])
    {
        bt.selected = NO;
    }
    NSInteger dicType = [[dic objectForKey:@"type"] integerValue];
    
    [self addSubview:label];
    
    if (_section == 0) {
        self.frame = CGRectMake(0, 0, kWidth, 50);
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
        view.backgroundColor =[UIColor colorFromHexRGB:@"e2e2e2"];
        [self addSubview:view];
        bt.frame = CGRectMake(bt.frame.origin.x
                              , bt.frame.origin.y+10, bt.frame.size.width, bt.frame.size.height);
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+10, label.frame.size.width+10, label.frame.size.height);
    }
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), label.frame.origin.y,kWidth-CGRectGetMaxX(label.frame)-70, label.frame.size.height)];
    lab1.font=[UIFont systemFontOfSize:15];
    lab1.textColor=[UIColor colorFromHexRGB:@"f5a623"];
    [self addSubview:lab1];
    
    if (dicType ==1) {
        label.text=@"我的商品";
        
        
    }
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, kWidth, 0.5)];
    line.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
    [self addSubview:line];

}

-(void)clickAll:(UIButton *)bt
{
    _blockBT(bt);
}


- (void)dealloc
{
    DLog(@"消失header了");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
