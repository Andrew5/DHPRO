//
//  BigSizeButton.m
//  zhundao
//
//  Created by zhundao on 2017/8/31.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import "BigSizeButton.h"

@implementation BigSizeButton


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
        //当前btn大小
        CGRect btnBounds = self.bounds;
        //扩大点击区域，想缩小就将-10设为正值
        btnBounds = CGRectInset(btnBounds, -20, -20);
        
        //若点击的点在新的bounds里，就返回YES
        return CGRectContainsPoint(btnBounds, point);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
