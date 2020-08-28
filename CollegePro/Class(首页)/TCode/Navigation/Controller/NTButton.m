//
//  NTButton.m
//  tabBarText
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NTButton.h"

@implementation NTButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark 设置button内部的image的范围

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = contentRect.size.width;
    //    CGFloat imageH = contentRect.size.height * 0.5;
    
    return CGRectMake((imageW -25)/2, 4, 25, 25);
    
}

#pragma mark 设置button内部的title的范围

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleY = contentRect.size.height * 0.4;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY +4, titleW, titleH);
    
}
@end
