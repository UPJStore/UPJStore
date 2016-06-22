//
//  OrderTableViewCell.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "UIViewController+CG.h"
#import "CommodView.h"
#import "CommodModel.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexRGB.h"

@implementation OrderTableViewCell
{
    UILabel *orderlabel;
    UILabel *alllabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(OrderModel*)model isEvaluate:(BOOL)isEvaluate
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //订单栏
        orderlabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 10,200, 12)];
        orderlabel.textColor =[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        orderlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        orderlabel.text = [@"订单号:" stringByAppendingString:model.ordersn];
        [self addSubview:orderlabel];
        //状态栏
        _statelabel = [[UILabel alloc]initWithFrame:CGRectMake1(356, 10, 48, 12)];
        _statelabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        _statelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        _statelabel.textAlignment = 2;
        [self addSubview:_statelabel];
        //分割线
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake1(0, 30, 414, 1)];
        line1.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];;
        [self addSubview:line1];
        
        for (int i = 0; i<model.goodArr.count; i++) {
            CommodView *commodView = [[CommodView alloc]initWithFrame:CGRectMake1(0, 30+100*i, 414, 100)];
            CommodModel *commodmodel = model.goodArr[i];
            commodView.nameLabel.text = commodmodel.title;
            commodView.moneylabel.text = [@"¥" stringByAppendingString:commodmodel.marketprice];
            commodView.numberlabel.text = [NSString stringWithFormat:@"共%@件",commodmodel.total];
            commodView.button.hidden = YES;
            [self addSubview:commodView];
            
            NSURL *url=[NSURL URLWithString:commodmodel.thumb];
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:url];
            imageView.frame  = CGRectMake1(10, 10, 85, 85);
            [imageView.layer setBorderWidth:0.5];
            [imageView.layer setCornerRadius:5];
            [imageView.layer setBorderColor:[UIColor colorFromHexRGB:@"e9e9e9"].CGColor];
            [commodView addSubview:imageView];
        }
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake1(0, 35+100*model.goodArr.count, 414, 1)];
        line2.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
        [self addSubview:line2];
  
        //总信息。
        alllabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 45+100*model.goodArr.count, 404, 12)];
        alllabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        alllabel.textAlignment = 2;
        alllabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        NSInteger i =0;
        for (CommodModel* model1 in model.goodArr) {
            i += model1.total.integerValue;
        }
            NSString *allprice = [NSString stringWithFormat:@"共%ld件 运费:¥%@ 总付:¥%@",i,model.dispatchprice,model.goodsprice];
           NSRange rang1 = NSMakeRange(6+[NSString stringWithFormat:@"%ld",i].length, 1+model.dispatchprice.length);
           NSRange rang2 = NSMakeRange(11+[NSString stringWithFormat:@"%ld",i].length+model.dispatchprice.length, model.goodsprice.length+1);
            NSMutableAttributedString * aSrt = [[NSMutableAttributedString alloc]initWithString:allprice];
            [aSrt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] range:rang1];
            [aSrt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1] range:rang2];
        alllabel.attributedText = aSrt ;
        [self addSubview:alllabel];
        
        _button1 = [[UIButton alloc]initWithFrame:CGRectMake1(260, 65+100*model.goodArr.count, 65, 22)];
        [_button1.layer setCornerRadius:3];
        [_button1.layer setBorderColor:[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1].CGColor];
   //     [_button1 setTitle:@"取消订单" forState:UIControlStateNormal];
        [_button1 setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1] forState:UIControlStateNormal];
        [_button1.layer setBorderWidth:0.5];
        _button1.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:_button1];
        
        _button2 = [[UIButton alloc]initWithFrame:CGRectMake1(335, 65+100*model.goodArr.count, 65, 22)];
        [_button2.layer setCornerRadius:3];
        [_button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button2.backgroundColor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        _button2.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:_button2];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake1(0, 100+100*model.goodArr.count, 414, 20)];
        view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
        
        [self addSubview:view];
        
    }
    return self;
}

-(void)buttonGetStrWithbutton1:(NSString*)str1 button2:(NSString*)str2
{
    if (![str1 isEqualToString:@"0"]) {
        [_button1 setTitle:str1 forState:UIControlStateNormal];
        _button1.hidden = NO;
    }else
    {
        _button1.hidden = YES;
    }
    if (![str2 isEqualToString:@"0"]) {
        [_button2 setTitle:str2 forState:UIControlStateNormal];
        _button2.hidden = NO;
    }else
    {
        _button2.hidden = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
