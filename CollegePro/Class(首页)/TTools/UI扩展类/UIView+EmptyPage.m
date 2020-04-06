//
//  UIView+EmptyPage.m
//  GHEmptyPage
//
//  Created by mac on 2019/11/29.
//  Copyright © 2019 Yeetied. All rights reserved.
//

#import "UIView+EmptyPage.h"
#import <objc/runtime.h>

@interface UIView()
@property (nonatomic , copy) EmptyPageDidClickReloadBlock didClickReloadBlock;

@end

@implementation UIView (EmptyPage)


static NSString *emptyPageDidClickReloadBlockKey = @"emptyPageDidClickReloadBlockKey";

- (void)hideEmptyPage {
    for (UIView *view in self.subviews) {
        if (view.tag == 10 || view.tag == 20|| view.tag ==30) {
            [view removeFromSuperview];
        }
    }
}

- (EmptyPageDidClickReloadBlock)didClickReloadBlock {
    return objc_getAssociatedObject(self, &emptyPageDidClickReloadBlockKey);
}

- (void)setDidClickReloadBlock:(EmptyPageDidClickReloadBlock)didClickReloadBlock {
    objc_setAssociatedObject(self, &emptyPageDidClickReloadBlockKey, didClickReloadBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showEmptyPage:(CGFloat)y imageName:(NSString *)imageName imageFrame:(CGRect)imageFrame didClickReloadBlock:(EmptyPageDidClickReloadBlock)didClickReloadBlock{
    UIView *backView = [[UIView alloc]init];
    backView.tag = 10;
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - y);
    [self addSubview:backView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 20;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame) + 10, imageFrame.size.width, 30)];
    [button setTitle:@"点击重试" forState:UIControlStateNormal];
    button.tag = 30;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    self.didClickReloadBlock = didClickReloadBlock;
    [backView addSubview:imageView];
}

- (void)clickButton {
    if (self.didClickReloadBlock) {
        self.didClickReloadBlock();
    }
}

@end

