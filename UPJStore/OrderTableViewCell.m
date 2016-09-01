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
    UIView *headView;
    UILabel *orderlabel;
    UILabel *alllabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(OrderModel*)model isEvaluate:(BOOL)isEvaluate
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 5
                                                                )];
        view.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
        
        [self addSubview:view];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake1(0, 4.5, 414,0.5)];
        line.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [view addSubview:line];
        //顶部栏
        headView = [[UIView alloc]initWithFrame:CGRectMake1(0, 5, 414, 30)];
        
        [self addSubview:headView];
        
        //订单栏
        orderlabel = [[UILabel alloc]initWithFrame:CGRectMake1(10,0,200, 30)];
        orderlabel.textColor =[UIColor blackColor];
        orderlabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        orderlabel.text = [@"订单号:" stringByAppendingString:model.ordersn];
        [headView addSubview:orderlabel];
        //时间栏
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(250, 0, 80, 30)];
        timeLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        timeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        timeLabel.text = [self timeWithcuo:model.createtime];
        [headView addSubview:timeLabel];
        //状态栏
        _statelabel = [[UILabel alloc]initWithFrame:CGRectMake1(325,0, 50, 30)];
        _statelabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        _statelabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        _statelabel.textAlignment = 2;
        [headView addSubview:_statelabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(385, 7, 16, 16)];
        imageView.image = [UIImage imageNamed:@"order.png"];
        [imageView.layer setCornerRadius:3];
        [headView addSubview:imageView];
        
        //分割线
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, kWidth, 0.5)];
        line1.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];;
        [self addSubview:line1];
        
        UIView *goodsView  = [[UIView alloc]initWithFrame:CGRectMake(0, line1.frame.origin.y, kWidth, CGFloatMakeY(100*model.goodArr.count))];
        [self addSubview:goodsView];
        
        for (int i = 0; i<model.goodArr.count; i++) {
            CommodView *commodView = [[CommodView alloc]initWithFrame:CGRectMake(0,CGFloatMakeY(100*i), kWidth, CGFloatMakeY(100))];
            CommodModel *commodmodel = model.goodArr[i];
            commodView.nameLabel.text = commodmodel.title;
            commodView.moneylabel.text = [@"¥" stringByAppendingString:commodmodel.marketprice];
            commodView.numberlabel.text = [NSString stringWithFormat:@"共%@件",commodmodel.total];
            commodView.goodDetailBtn.hidden = YES;
            commodView.button.hidden = YES;
            [self addSubview:commodView];
            
            NSURL *url=[NSURL URLWithString:commodmodel.thumb];
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"lbtP"]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame  = CGRectMake1(15, 15, 70, 70);
         //   [imageView.layer setBorderWidth:0.5];
            [imageView.layer setCornerRadius:5];
         //   [imageView.layer setBorderColor:[UIColor colorFromHexRGB:@"e9e9e9"].CGColor];
            [commodView addSubview:imageView];
            
            UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake1(10, 99.5, 404, 0.5)];
            line2.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
            [commodView addSubview:line2];
            [goodsView addSubview:commodView];
        }
        
        UIView *InformationView = [[UIView alloc]initWithFrame:CGRectMake(0, goodsView.frame.origin.y+goodsView.frame.size.height, kWidth,CGFloatMakeY(40))];
        [self addSubview:InformationView];
        //总信息。
        alllabel = [[UILabel alloc]initWithFrame:CGRectMake1(10,0, 414, 40)];
        // alllabel.backgroundColor = [UIColor redColor];
        alllabel.textColor = [UIColor blackColor];
        //  alllabel.textAlignment = 2;
        alllabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        NSInteger i =0;
        for (CommodModel* model1 in model.goodArr) {
            i += model1.total.integerValue;
        }
        NSString *allprice = [NSString stringWithFormat:@"合计 : ¥%@",model.goodsprice];
        NSRange rang1 = NSMakeRange(5, model.goodsprice.length+1);
        NSMutableAttributedString * aSrt = [[NSMutableAttributedString alloc]initWithString:allprice];
        [aSrt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rang1];
        alllabel.attributedText = aSrt ;
        [InformationView addSubview:alllabel];
        
        _button1 = [[UIButton alloc]initWithFrame:CGRectMake1(255, 7, 65, 26)];
        [_button1.layer setCornerRadius:3];
        [_button1.layer setBorderColor:[UIColor colorFromHexRGB:@"babcbb"].CGColor];
        [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button1.layer setBorderWidth:0.5];
        _button1.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
        [InformationView addSubview:_button1];
        
        _button2 = [[UIButton alloc]initWithFrame:CGRectMake1(335, 7, 65, 26)];
        [_button2.layer setCornerRadius:3];
        [_button2.layer setBorderColor:[UIColor colorFromHexRGB:@"babcbb"].CGColor];
        [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button2.backgroundColor = [UIColor whiteColor];
        [_button2.layer setBorderWidth:0.5];
        _button2.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
        [InformationView addSubview:_button2];
        
        UIView* endlineView = [[UIView alloc]initWithFrame:CGRectMake(0, InformationView.frame.origin.y+InformationView.frame.size.height-CGFloatMakeY(0.5), kWidth, CGFloatMakeY(0.5))];
        endlineView.backgroundColor = [UIColor colorFromHexRGB:@"babcbb"];
        [self addSubview:endlineView];
        
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

//时间戳
-(NSString *)timeWithcuo:(NSString*)cuo
{
    NSTimeInterval time=[cuo doubleValue];
    //+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate: detaildate];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
