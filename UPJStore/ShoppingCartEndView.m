//
//  ShoppingCartEndView.m
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShoppingCartEndView.h"
#import "ShoppingCartViewController.h"

@interface ShoppingCartEndView ()

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIButton * pushBtn;

@end

static CGFloat VIEW_HEIGHT = 44 ;

@implementation ShoppingCartEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addObserver:self forKeyPath:@"isEdit" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self initView];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isEdit"]) {
        if (self.isEdit) {
            
            _Lab.hidden = YES;
            _deleteBtn.hidden = NO;
            _pushBtn.hidden = YES;
            
        }else
        {
            _Lab.hidden =NO;
            _deleteBtn.hidden= YES;
            _pushBtn.hidden =NO;
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isEdit"];
}

-(void)initView
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    line.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
    [self addSubview:line];
    UIImage *btimg = [UIImage imageNamed:@"UnSelected"];
    UIImage *selectImg = [UIImage imageNamed:@"Selected"];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(5, self.frame.size.height/2-btimg.size.height/2, btimg.size.width+60, btimg.size.height)];
    bt.selected=YES;
    [bt addTarget:self action:@selector(clickAllEnd:) forControlEvents:UIControlEventTouchUpInside];
    [bt setImage:btimg forState:UIControlStateNormal];
    [bt setImage:selectImg forState:UIControlStateSelected];
    
    [bt setTitle:@"全选" forState:UIControlStateNormal];
    bt.titleLabel.font =[UIFont systemFontOfSize:13];
    [bt setTitle:@"取消全选" forState:UIControlStateSelected];
    [bt setTitleColor:[UIColor colorFromHexRGB:@"666666"] forState:UIControlStateNormal];
    
    [self addSubview:bt];
    
    _Lab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt.frame)+10, 0, 150, self.frame.size.height)];
    
    _Lab.textColor=[UIColor colorFromHexRGB:@"666666"];
    _Lab.text=[NSString stringWithFormat:@"合计: ￥ 0"];
    _Lab.font=[UIFont systemFontOfSize:15];
    
    [self addSubview:_Lab];
    
    
    _pushBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-15-80, 5, 80, 30)];
    _pushBtn.hidden=NO;
    _pushBtn.tag=18;
    [_pushBtn setTitle:@"结算" forState:UIControlStateNormal];
    _pushBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _pushBtn.backgroundColor=[UIColor colorFromHexRGB:@"fb5d5d"];
    [[_pushBtn layer]setCornerRadius:3.0];
    [_pushBtn addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_pushBtn];
    
    
    
    
    _deleteBtn = [[UIButton alloc]initWithFrame:_pushBtn.frame];
    _deleteBtn.hidden=YES;
    [_deleteBtn setTitleColor:[UIColor colorFromHexRGB:@"fb5d5d"] forState:UIControlStateNormal];
    _deleteBtn.tag=19;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _deleteBtn.backgroundColor=[UIColor whiteColor];
    [[_deleteBtn layer]setCornerRadius:3.0];
    [_deleteBtn.layer setBorderWidth:0.5];
    [_deleteBtn addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.layer.borderColor = [[UIColor colorFromHexRGB:@"fb5d5d"] CGColor];
    
    
    [self addSubview:_deleteBtn];

}


-(void)clickRightBT:(UIButton *)bt
{
    [self.delegate clickRightBtn:bt];
}


-(void)clickAllEnd:(UIButton *)bt
{
    
    
    [self.delegate clickAllEnd:bt];
    
}
- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
}


+ (CGFloat)getViewHeight
{
    return VIEW_HEIGHT;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
