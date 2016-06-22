//
//  OrderAddressTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/4/13.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "OrderAddressTableViewCell.h"
#import "UIViewController+CG.h"
@implementation OrderAddressTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake1(5, 40, 20, 20)];
        imageView.image = [UIImage imageNamed:@"地标_2"];
        [self.contentView addSubview:imageView];
        UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake1(414-20, 40, 20, 20)];
        arrowImageView.image = [UIImage imageNamed:@"前进"];
        [self.contentView addSubview:arrowImageView];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake1(40, 20, 354/2, 20)];
        _nameLab.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        [self.contentView addSubview:_nameLab];
        
        _mobileLab = [[UILabel alloc]initWithFrame:CGRectMake1(394/2, 20, 354/2, 20)];
        _mobileLab.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        _mobileLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_mobileLab];
        
        _addressLab = [[UILabel alloc]initWithFrame:CGRectMake1(40, 40, 414-60, 50)];
        _addressLab.font = [UIFont systemFontOfSize:CGFloatMakeY(15)];
        _addressLab.numberOfLines = 0 ;
        [self.contentView addSubview:_addressLab];
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
