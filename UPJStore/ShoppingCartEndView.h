//
//  ShoppingCartEndView.h
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCartEndViewDelegate;

@interface ShoppingCartEndView : UIView

@property (nonatomic,assign) BOOL isEdit ;
@property (nonatomic,weak) id<ShoppingCartEndViewDelegate>delegate;
@property (nonatomic,strong) UILabel *Lab;

+(CGFloat)getViewHeight;

@end

@protocol ShoppingCartEndViewDelegate <NSObject>

-(void)clickAllEnd:(UIButton*)btn;

-(void)clickRightBtn:(UIButton*)btn;

@end
