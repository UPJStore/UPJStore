//
//  ComfirmOrderTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/4/12.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ComfirmOrderTableViewCell.h"
#import "UIViewController+CG.h"
@implementation ComfirmOrderTableViewCell

// 初始化cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        
        _productImg = [[UIImageView alloc]initWithFrame:CGRectMake1(10, 10,70, 80)];
        _productImg.backgroundColor = [UIColor whiteColor];
        _productImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_productImg];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake1(90,10,414-200,50)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        [self.contentView addSubview:_titleLabel];
        
        _totalPrice = [[UILabel alloc]initWithFrame:CGRectMake1(330,20,74,20)];
        _totalPrice.textColor =  [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
        _totalPrice.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
        _totalPrice.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_totalPrice];
        
        _total = [[UILabel alloc]initWithFrame:CGRectMake1(340,40,64,20)];
        _total.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
        _total.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        _total.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_total];
    }
    return self;
    
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
