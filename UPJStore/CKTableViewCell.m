//
//  CKTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/5/25.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "CKTableViewCell.h"
#import "UIViewController+CG.h"
#import "UIColor+HexRGB.h"

@interface CKTableViewCell ()

{
    UILabel * nameLabel;
    UILabel *createTimeLabel;
    UILabel *recommendPerLabel;
    UILabel * CKLogo;
}

@end

@implementation CKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

        _avatarVIew = [[UIImageView alloc]initWithFrame:CGRectMake1(20, 20, 80, 80)];
        _avatarVIew.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_avatarVIew];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 20, 250, 20)];
        nameLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
        [self.contentView addSubview:nameLabel];
        
        createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 50, 250, 20)];
        createTimeLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
        [self.contentView addSubview:createTimeLabel];
        
        
        recommendPerLabel = [[UILabel alloc]initWithFrame:CGRectMake1(120, 80, 250, 20)];
        recommendPerLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(13)];
        [self.contentView addSubview:recommendPerLabel];
        
            CKLogo = [[UILabel alloc]initWithFrame:CGRectMake1(300, 50, 50, 20)];
            CKLogo.layer.borderWidth = 1;
            CKLogo.layer.borderColor = [[UIColor colorFromHexRGB:@"cc2245"]CGColor];
            CKLogo.text = @"创客";
            CKLogo.textAlignment = NSTextAlignmentCenter;
            CKLogo.textColor = [UIColor colorFromHexRGB:@"cc2245"];
            CKLogo.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
            CKLogo.hidden = YES;
            [self.contentView addSubview:CKLogo];
       
        

    }
    
    
    
    return self;

}

-(void)initWithModel:(CKModel*)model
    {
        nameLabel.text = [NSString stringWithFormat:@"昵称： %@",model.nickname];
        
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"关注时间： %@",[self timeWithcuo:model.createtime]]];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"999999"] range:NSMakeRange(0, 5)];
        createTimeLabel.attributedText = attr;
    
        NSMutableAttributedString * attr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"推荐上级： %@",model.tui]];
        [attr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:@"999999"] range:NSMakeRange(0, 5)];
        recommendPerLabel.attributedText = attr1;
        
        if ([model.flag isEqualToString:@"1"]) {
            CKLogo.hidden = NO;
        }
    }

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
