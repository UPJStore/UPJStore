//
//  CKTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/5/25.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKModel.h"

@interface CKTableViewCell : UITableViewCell

@property (nonatomic,strong) CKModel *model;
@property (nonatomic,strong) UIImageView * avatarVIew;

-(void)initWithModel:(CKModel*)model;

@end
