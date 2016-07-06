//
//  DetialTableViewCell.m
//  HomePage-3
//
//  Created by upj on 16/6/29.
//  Copyright © 2016年 upj. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIViewController+CG.h"

@implementation DetailTableViewCell
{
    UIView *lineView;
    UIButton *btn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ProductModel *)model
{
    _model = model;
    self.detailtitleLabel.text = model.title;
    self.marketLabel.text = [NSString stringWithFormat:@"¥ %@",model.marketprice];
    self.productLabel.text = [NSString stringWithFormat:@"¥ %@",model.productprice];
    [self.salesBtn setTitle:[NSString stringWithFormat:@"销量:%@",model.sales] forState:UIControlStateNormal];
    if (model.descriptionStr.length != 0) {
        self.desLabel.text = model.descriptionStr;
    }
    if (model.marketprice.length == 5) {
        lineView.frame = CGRectMake1(69, 360, 1, 20);
        self.productLabel.frame = CGRectMake1(73, 350, 55, 40);
        btn.frame = CGRectMake1(9, 355, 115, 30);
        if (model.productprice.length == 5) {
            btn.frame = CGRectMake1(9, 355, 110, 30);
        }
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, 414, 40)];
        self.titleLabel.textAlignment = 1;
        self.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        
        self.footView = [[UIView alloc]init];
        self.footView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.footView];
        
        self.detailImg = [[UIImageView alloc]initWithFrame:CGRectMake1(82, 0, 250, 250)];
        [self addSubview:self.detailImg];
        
        self.detailtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 250, 394, 40)];
        self.detailtitleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(14)];
        self.detailtitleLabel.numberOfLines = 0;
        [self addSubview:self.detailtitleLabel];
        
        self.desLabel = [[myUILabel alloc]initWithFrame:CGRectMake1(10, 290, 394, 60)];
        self.desLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        self.desLabel.numberOfLines = 0;
        self.desLabel.verticalAlignment = VerticalAlignmentTop;
        [self addSubview:self.desLabel];
        
        self.marketLabel = [[UILabel alloc]initWithFrame:CGRectMake1(10, 350, 70, 40)];
        self.marketLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        self.marketLabel.textColor = [UIColor redColor];
        self.marketLabel.textAlignment = 0;
        [self addSubview:self.marketLabel];
        
        lineView =[[UIView alloc]initWithFrame:CGRectMake1(79, 360, 1, 20)];
        lineView.backgroundColor = [UIColor redColor];
        [self addSubview:lineView];
        
        self.productLabel = [[LineLabel alloc]initWithFrame:CGRectMake1(83, 350, 55, 40)];
        self.productLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        self.productLabel.textColor = [UIColor grayColor];
        self.productLabel.textAlignment = 0;
        self.productLabel.lineType = LineTypeMiddle;
        [self addSubview:self.productLabel];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor redColor].CGColor;
        btn.frame = CGRectMake1(9, 355, 125, 30);
        [self addSubview:btn];
        
        self.salesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.salesBtn.layer.borderWidth = 0.5;
        self.salesBtn.layer.cornerRadius = 5;
        self.salesBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.salesBtn.frame = CGRectMake1(320, 355, 80, 30);
        [self.salesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.salesBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:self.salesBtn];
        
        self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionBtn.layer.borderWidth = 0.5;
        self.attentionBtn.layer.cornerRadius = 5;
        self.attentionBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.attentionBtn.frame = CGRectMake1(340, 20, 60, 30);
         [self.attentionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
         self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(12)];
        [self addSubview:self.attentionBtn];
    }
    return self;
}


-(void)change
{
    self.detailImg.frame = CGRectMake1(82, 40, 250, 250);
    self.detailtitleLabel.frame = CGRectMake1(10, 290, 394, 40);
     self.desLabel.frame = CGRectMake1(10, 330, 394, 60);
    self.marketLabel.frame = CGRectMake1(10, 390, 70, 40);
    lineView.frame = CGRectMake1(79, 400, 1, 20);
    self.productLabel.frame = CGRectMake1(83, 390, 55, 40);
    btn.frame = CGRectMake1(9, 395, 125, 30);
     self.salesBtn.frame = CGRectMake1(320, 395, 80, 30);
    self.attentionBtn.frame = CGRectMake1(340, 60, 60, 30);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
