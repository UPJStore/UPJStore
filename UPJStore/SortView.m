//
//  SortView.m
//  UPJStore
//
//  Created by upj on 16/3/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//


#import "SortView.h"
#import "SortModel.h"
#import "UIView+cg.h"
#define kSViewWidth self.frame.size.width
#define kSViewHeight self.frame.size.height

@implementation SortView
{
    //每行的间隔
    CGFloat spacing ;
    //每行没突出前的总和
    //    CGFloat lenght;
    //最小间距
    CGFloat minSpace;
    //之前有多少个字段
    //    int beforeCount;
    //每行的第几个字段
    int count;
    //第几行
    //    int lineCount;
    
    //    CGFloat beforeBtnWidth ;
    
    UIButton *btn;
    NSDictionary *attributes;
}



-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)arr
{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    //    count = 1;
    minSpace = 10;
    //    beforeCount = 1;
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = (150*app.autoSizeScaleY)*414/320+10;//用来控制button距离父视图的高
    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*app.autoSizeScaleY]};
    if (self = [super initWithFrame:frame]) {
        //        self.backgroundColor = [UIColor blackColor];
        for (NSDictionary * dic in arr) {
            
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            //            DLog(@"title : %@",model.name);
            
            //            btn.backgroundColor = [UIColor blackColor];
            if ([dic[@"hot"] isEqualToString:@"1"]) {
                [btn setTitleColor:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] forState:UIControlStateNormal];
            }else [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
            //            [self isprominent];
            
            CGFloat length = [dic[@"name"] boundingRectWithSize:CGSizeMake(kSViewWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            //            DLog(@"%f",length);
            //设置button的frame
            btn.titleLabel.font = [UIFont systemFontOfSize:15*app.autoSizeScaleY];
            [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(minSpace + w, h, length + 15 , 30);
            count ++;
            //            DLog(@"%d",count);
            
            //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
//            DLog(@"%f",kSViewWidth);
            if(minSpace+ w + length + 15 > kSViewWidth){
                w = 0; //换行时将w置为0
                h = h + btn.frame.size.height ;//距离父视图也变化
                btn.frame = CGRectMake(minSpace+ w, h, length + 15, 30);//重设button的frame
                count = 0 ;
            }
            w = btn.frame.size.width + btn.frame.origin.x;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y, kSViewWidth, h+btn.frame.size.height +10);
    }
    return self;
}


-(void)btnAction:(UIButton *)Acbtn
{
    [self.delegate BtnAction:Acbtn];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
