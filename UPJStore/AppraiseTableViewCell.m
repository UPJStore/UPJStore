//
//  AppraiseTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/4/7.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "AppraiseTableViewCell.h"
#import "UIColor+HexRGB.h"
#import "UIView+cg.h"

@interface AppraiseTableViewCell  ()
{
    UILabel *nameLabel;
    UILabel * ContentLabel ;
    UIView * lightView ;
    
}
@end

@implementation AppraiseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake1(5, 9, 200, 20)];
        nameLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        [self.contentView addSubview:nameLabel];
        
        for (int j = 0; j<5; j++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(414-60+j*10, 9, 10, 10)];
            imageView.image = [UIImage imageNamed:@"starIcon"];
            imageView.tag = j+1;
            [self.contentView addSubview:imageView];
            imageView.hidden = YES;
        }
        
        ContentLabel = [[UILabel alloc]initWithFrame:CGRectMake1(5, 45, 404, 0)];
        ContentLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        ContentLabel.numberOfLines = 0;
        ContentLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        [self.contentView addSubview: ContentLabel];

        lightView = [[UIView alloc]initWithFrame:CGRectMake(0, CGFloatMakeY(65), kWidth, CGFloatMakeY(10))];
        lightView.backgroundColor = [UIColor colorFromHexRGB:@"f6f6f6"];
        [self.contentView addSubview:lightView];

    }
    return self;
}

-(void)initWithModel
{
    nameLabel.text = _model.nickname;

    
    for (int j = 0; j<[_model.star integerValue]; j++)
    {
        [[self.contentView viewWithTag:j+1] setHidden:NO];
    }
    CGFloat DesLength = [_model.content boundingRectWithSize:CGSizeMake(414, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CGFloatMakeY(15)]} context:nil].size.height;
    
        ContentLabel.text = _model.content;
    ContentLabel.frame =CGRectMake1(5, 45, 404, DesLength);
    
    self.contentView.frame =CGRectMake(0, 0, self.contentView.frame.size.width,CGFloatMakeY(65+DesLength+20));

    lightView.frame =CGRectMake(0, CGFloatMakeY(65+DesLength), kWidth, CGFloatMakeY(10));

    self.frame = self.contentView.frame;
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
