//
//  LeftContainerView.m
//  CollegePro
//
//  Created by jabraknight on 2021/6/14.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "LeftContainerView.h"

@implementation LeftContainerView
- (instancetype)initWithCustomView:(UIView *)customView {
    if (self = [super initWithFrame:customView.bounds]) {
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:customView];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self removeObserver:self forKeyPath:@"frame"];
    if ([keyPath isEqualToString:@"frame"]) {
        if ([self.superview.superview isKindOfClass:NSClassFromString(@"_UIButtonBarStackView")]) {
            self.superview.superview.transform = CGAffineTransformMakeTranslation(-16, 0);
        } else {
            self.frame = self.bounds;
        }
    }
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
