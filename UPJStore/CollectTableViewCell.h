//
//  CollectTableViewCell.h
//  UPJStore
//
//  Created by 邝健锋 on 16/4/6.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView* pictureView;

@property(nonatomic,strong)UILabel* titlelabel;

@property(nonatomic,strong)UILabel* pricelabel;

-(void)getImageViewWithstr:(NSString*)str;

@end
