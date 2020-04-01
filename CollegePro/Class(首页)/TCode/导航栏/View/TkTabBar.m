//
//  TkTabBar.m
//  TuoKe
//
//  Created by jabraknight on 2017/3/21.
//  Copyright © 2017年 tuoke. All rights reserved.
//

#import "TkTabBar.h"

@implementation TkTabBar

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc]init];
    }
    return _backgroundView;
}
- (UIButton *)plusBtn{
    if(!_plusBtn){
        _plusBtn = [[UIButton alloc]init];
        _plusBtn.adjustsImageWhenHighlighted=NO;
        [_plusBtn setImage:[UIImage imageNamed:@"ic_fast_order"]forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"ic_fast_order"] forState:UIControlStateSelected];
        [_plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    [self setUpAllChildTabBarButtonFrame];
//    self.backgroundImage = [UIImage new];
//    self.shadowImage = [UIImage new];
    self.backgroundView.frame=self.bounds;
    self.backgroundView.image=[UIImage imageNamed:@"nc_tabbar"];
    

    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width/(self.items.count +1);//375
    CGFloat btnH = self.bounds.size.height;//49
    
    int i =0;
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i==0) {
                [self insertSubview:self.backgroundView belowSubview:tabBarButton];
            }
            if (i == 1) {
                i = 2;
            }
            btnX = i * btnW;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i ++;
        }
    }
    CGFloat width=30.f;
    self.plusBtn.frame=CGRectMake(self.bounds.size.width/2-width, -14, 60, 60);
    [self addSubview:self.plusBtn];
}
-(void)plusBtnClick:(UIButton *)sender{
    sender.selected=!sender.selected;
//    self.clickBlock(sender.selected);
    NSLog(@"中间按钮点击");
}


//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self insertSubview:backView atIndex:0];
//    self.opaque = YES;
//    
//    return  self;
//}

/**
 *  设置全部的tabbarButton的frame
 */
- (void)setUpAllChildTabBarButtonFrame {
    
    int index = 0;
    
    for (UIView *tabBarButton in self.subviews) {
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            continue;
        }
        [self setUpTabBarButtonFrame:tabBarButton atIndex:index];
        index++;
    }
}


/**
 *  设置每个tabBarButton的frame
 *
 *  @param tabBarButton 需要设置的tabbarButton
 *  @param index        tabbarButton所在的索引值
 */
- (void)setUpTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index {
    
    CGFloat buttonW = self.width / self.items.count;
    CGFloat buttonH = self.height;
    
    tabBarButton.width = buttonW;
    tabBarButton.height = buttonH;
    tabBarButton.left = buttonW*index;
    tabBarButton.top = 0;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
