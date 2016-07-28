//
//  ImageTableViewCell.h
//  UPJStore
//
//  Created by upj on 16/7/21.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *label2;
@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, strong) UIButton *btn2;
@property(nonatomic, strong) UIButton *btn3;

-(void)setImageWithImage1:(NSString*)image;

-(void)setImageWithImage2:(NSString*)image;

-(void)setImageWithImage3:(NSString*)image;


@end
