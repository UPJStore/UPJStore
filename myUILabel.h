//
//  myUILabel.h
//  UPJStore
//
//  Created by upj on 16/6/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface myUILabel : UILabel
{
@private
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
