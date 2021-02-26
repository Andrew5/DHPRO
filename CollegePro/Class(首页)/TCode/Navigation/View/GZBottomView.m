//
//  GZBottomVIew.m
//  GomeZk
//
//  Created by jabraknight on 2021/2/24.
//

#import "GZBottomView.h"

@implementation GZBottomView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *tmpView = [super hitTest:point withEvent:event];
    if (tmpView == nil) {
        CGPoint newPoint = [self.selectedView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.selectedView.bounds,newPoint)) {
            tmpView = self.selectedView;
        }
    }
    return tmpView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
