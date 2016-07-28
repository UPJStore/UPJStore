//
//  ImageTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/7/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIButton+WebCache.h"

@implementation ImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake1(0, 0, kWidth, 50)];
        _label1.textAlignment = 1;
        _label1.numberOfLines = 0;
        [self addSubview:_label1];
        
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake1(0, 220, kWidth, 50)];
        _label2.textAlignment = 1;
        _label2.numberOfLines = 0;
        NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:@"全球购物体验站\nUPIN SHOP SHOPPING OVERSEAS"];
        [attributeString1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(14)]} range:NSMakeRange(0, 7)];
        [attributeString1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:CGFloatMakeY(8)]} range:NSMakeRange(7,28)];
        _label2.attributedText = attributeString1;
        [self addSubview:_label2];
        
        if ([reuseIdentifier isEqualToString:@"imagecell1"]) {
            
            _btn1 = [[UIButton alloc]initWithFrame:CGRectMake1(15, 50, (kWidth-50)/3, 170)];
            
            [self addSubview:_btn1];
            
            _btn2 = [[UIButton alloc]initWithFrame:CGRectMake1(25+(kWidth-50)/3, 50, (kWidth-50)/3, 170)];
           
            [self addSubview:_btn2];
            
            _btn3 = [[UIButton alloc]initWithFrame:CGRectMake1(35+(kWidth-50)/3*2, 50, (kWidth-50)/3, 170)];
            
            [self addSubview:_btn3];
        }
        if ([reuseIdentifier isEqualToString:@"imagecell2"]) {
            _btn1 = [[UIButton alloc]initWithFrame:CGRectMake1(15, 50, kWidth-30, 150)];
            
            [self addSubview:_btn1];
        }
    }
    return self;
}

-(void)setImageWithImage1:(NSString *)image
{
    
    [_btn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal];
}

-(void)setImageWithImage2:(NSString *)image
{
    [_btn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal];
}

-(void)setImageWithImage3:(NSString *)image
{
    [_btn3 sd_setBackgroundImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
