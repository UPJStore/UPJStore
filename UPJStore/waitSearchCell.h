//
//  waitSearchCell.h
//  UPJStore
//
//  Created by upj on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol waitSearchDelegate;

@interface waitSearchCell : UITableViewCell

@property (weak,nonatomic) id<waitSearchDelegate> delegate;

-(CGFloat)addBtnWithArr:(NSMutableArray *)arr;
@end

@protocol waitSearchDelegate <NSObject>

-(void)SearchBtnAction:(UIButton*)btn;


@end
