//
//  XZBaseMenu.h
//  XZActionView
//
//  Created by Txj on 14-11-26.
//  Copyright (c) 2014年 Txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZActionView.h"

#define BaseMenuBackgroundColor(style)  (style == XZActionViewStyleLight ? [UIColor colorWithWhite:1.0 alpha:1.0] : [UIColor colorWithWhite:0.2 alpha:1.0])
#define BaseMenuTextColor(style)        (style == XZActionViewStyleLight ? [UIColor darkTextColor] : [UIColor lightTextColor])
#define BaseMenuActionTextColor(style)  ([UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0])

@interface XZButton : UIButton
@end

@interface XZBaseMenu : UIView{
    XZActionViewStyle _style;
}

// if rounded top left/right corner, default is YES.
@property (nonatomic, assign) BOOL roundedCorner;

@property (nonatomic, assign) XZActionViewStyle style;

@end
