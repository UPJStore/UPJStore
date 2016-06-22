//
//  AfterSearchViewController.h
//  UPJStore
//
//  Created by upj on 16/3/23.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AfterSearchViewController : UIViewController

@property (nonatomic,strong) NSString *KeyWord;
@property (nonatomic,assign) BOOL isFromBtn;
@property (nonatomic,assign) BOOL isFromLBT;
@property (nonatomic,strong)UIColor *backgroundColor;
@property (nonatomic,strong) NSString *advname, *descriptionText, *thumb;

@end
