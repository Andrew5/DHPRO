//
//  UIScrollView+PullBig.m
//  CollegePro
//
//  Created by Rillakkuma on 2018/11/29.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "UIScrollView+PullBig.h"
#import <objc/runtime.h>
@interface PullBigEffectView:UIView
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign, getter=isfirstLayoutSubviews) BOOL firstLayoutSubviews;
@property (nonatomic, assign) CGFloat headerH;
@end
NSString *const ContentOffset = @"contentOffset";
@implementation PullBigEffectView
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self.superview removeObserver:self forKeyPath:ContentOffset context:nil];
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:ContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self isfirstLayoutSubviews]) {
        UIScrollView *superView = (UIScrollView *)self.superview;
        UIView *headerView = superView.headerView;
        UIView *bigView =superView.bigView;
        self.frame = headerView ? headerView.bounds : bigView.bounds;
        self.headerH = headerView ? headerView.bounds.size.height : bigView.bounds.size.height;
        CGRect selfFrame = self.frame;
        selfFrame.origin.y = -self.headerH;
        self.frame = selfFrame;
        superView.contentInset = UIEdgeInsetsMake(superView.contentInset.top+self.headerH, 0, 0, 0);
        CGRect headerViewFrame = headerView.frame;
        headerViewFrame.origin.y = -self.headerH;
        headerView.frame = headerViewFrame;
        
        self.contentInset = superView.contentInset;
        [superView setContentOffset:CGPointMake(0, -self.contentInset.top) animated:NO];
        self.firstLayoutSubviews = false;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:ContentOffset] && !self.isfirstLayoutSubviews) {
        [self animationHandle:[[object valueForKey:ContentOffset] CGPointValue]];
    }
}

-(void)animationHandle:(CGPoint)offset
{
    CATransform3D transform = CATransform3DIdentity;
    if (offset.y < -self.contentInset.top)
    {
        CGFloat offsetY = (offset.y + self.contentInset.top)/2;
        CGFloat scaleNumber = ((self.headerH-offset.y)-self.contentInset.top)/self.headerH;
        transform = CATransform3DTranslate(transform, 0, offsetY, 0);
        transform = CATransform3DScale(transform, scaleNumber, scaleNumber, 1);
        self.layer.transform = transform;
    }
    else
    {
        self.layer.transform = transform;
    }
}
@end

@interface UIScrollView()
@end
static char bigViewKey;
static char headerViewKey;
@implementation UIScrollView (PullBig)
-(void)setBigView:(UIView *)bigView withHeaderView:(UIView *)headerView
{
    if (!bigView) {
        return;
    }
    self.bigView = bigView;
    headerView.backgroundColor = [UIColor clearColor];
    self.headerView = headerView;
    [self setup];
}

-(void)setBigView:(UIView *)bigView
{
    [self.bigView removeFromSuperview];
    objc_setAssociatedObject(self, &bigViewKey, bigView, OBJC_ASSOCIATION_RETAIN);
}

-(UIView *)bigView
{
    return objc_getAssociatedObject(self, &bigViewKey);
}

-(void)setHeaderView:(UIView *)headerView
{
    [self.headerView removeFromSuperview];
    objc_setAssociatedObject(self, &headerViewKey, headerView, OBJC_ASSOCIATION_RETAIN);
}

-(UIView *)headerView
{
    return objc_getAssociatedObject(self, &headerViewKey);
}

-(void)setup
{
    PullBigEffectView *effectView = [[PullBigEffectView alloc] init];
    effectView.layer.masksToBounds = YES;
    effectView.firstLayoutSubviews = YES;
    [effectView addSubview:self.bigView];
    [self insertSubview:effectView atIndex:0];
    [self insertSubview:self.headerView aboveSubview:effectView];
}
@end
