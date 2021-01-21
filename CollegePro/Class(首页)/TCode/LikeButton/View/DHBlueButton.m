//
//  DHBlueButton.m
//  CollegePro
//
//  Created by jabraknight on 2021/1/21.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "DHBlueButton.h"

@implementation DHBlueButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha < 0.01) return nil;
//
//    if (![self pointInside:point withEvent:event]) return nil;
//
//    int count = (int)self.subviews.count;
//    for (int i = count-1; i >=0; i--) {
//        UIView *childView = self.subviews[i];
//        CGPoint childPoint = [self convertPoint:point toView:childView];
//        UIView *view = [childView hitTest:childPoint withEvent:event];
//        if (view) return view;
//    }
    
    CGPoint redBtnPoint = [self convertPoint:point toView:_redButton];
//    if ([_redButton pointInside:redBtnPoint withEvent:event]) {
//        return _redButton;
//    }
        //如果希望严谨一点，可以将上面if语句及里面代码替换成如下代码
    UIView *view = [_redButton hitTest: redBtnPoint withEvent: event];
    if (view) return view;
    return [super hitTest:point withEvent:event];

//    return self;
}
@end
