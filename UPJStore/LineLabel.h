//
//  LineLabel.h
//  UPJStore
//
//  Created by upj on 16/6/17.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    LineTypeNone,//没有画线
    LineTypeUp ,// 上边画线
    LineTypeMiddle,//中间画线
    LineTypeDown,//下边画线
    
} LineType ;


@interface LineLabel : UILabel

@property (assign, nonatomic) LineType lineType;
@property (assign, nonatomic) UIColor * lineColor;

@end
