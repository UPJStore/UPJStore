//
//  AttentionTableViewCell.h
//  UPJStore
//
//  Created by 邝健锋 on 16/4/9.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttentionCancelAction;

@interface AttentionTableViewCell : UITableViewCell

@property(nonatomic,assign)id <AttentionCancelAction>delegate;

@property(nonatomic,strong)UIImageView *pictureView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)NSString *pid;

@property(nonatomic,strong)NSString *mid;

-(void)getImageViewWithstr:(NSString*)str;

@end

@protocol AttentionCancelAction <NSObject>

-(void)AttentionCancelWithdic:(NSDictionary*)dic;

@end
