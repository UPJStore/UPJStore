//
//  recommandCell.h
//  UPJStore
//
//  Created by upj on 16/6/22.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineLabel.h"

@interface recommandCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView * goodsImageView;
@property (nonatomic,strong) UILabel  *marketLabel, *titleLabel;
@property (nonatomic,strong) LineLabel *productLabel;

@end
