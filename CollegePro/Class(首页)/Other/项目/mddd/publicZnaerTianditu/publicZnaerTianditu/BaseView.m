//
//  BaseView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/19.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)initWithController:(UIViewController *)vc;
{
    CGRect frame = vc.view.frame;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.controller = vc;
      
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        self.NavigateBarHeight = 44;
#else
        self.NavigateBarHeight = 64;
#endif
        
       [self layoutView:frame];
        
    }
    return self;
}

-(void)layoutView:(CGRect)frame
{
}

-(UIColor *)retRGBColorWithRed:(int)r andGreen:(int)g andBlue:(int)b
{
    return [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f];
}

-(CGFloat)relativeX:(CGRect)frame withOffX:(CGFloat)dX
{
    return frame.origin.x + frame.size.width +dX;
}

-(CGFloat)relativeY:(CGRect)frame withOffY:(CGFloat)dY
{
    return frame.origin.y + frame.size.height + dY;
}

-(void)doAction:(UIButton *)sender{
    self.btnClickBlack(sender);
}

@end
