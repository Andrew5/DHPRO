//
//  UITabBar+XSDExt.m
//  SpeedAcquisitionloan
//
//  Created by Uwaysoft on 2018/6/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UITabBar+XSDExt.h"
#define TabbarItemNums  5.0    //tabbar的数量 如果是5个设置为5  
@implementation UITabBar (XSDExt)
//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index numberWithInt:(NSString *)tag{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    
    //新建小红点
    UILabel *lb_point = [[UILabel alloc]init];
    lb_point.tag = 888 + index;
    lb_point.text = tag;
    lb_point.layer.cornerRadius = 16.0/2;//圆形
    lb_point.textAlignment = NSTextAlignmentCenter;
    [lb_point setTextColor:[UIColor whiteColor]];
    [lb_point setFont:[UIFont systemFontOfSize:8]];
    lb_point.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
//    UIView *badgeView = [[UIView alloc]init];
//    badgeView.tag = 888 + index;
//    badgeView.layer.cornerRadius = 5.0;//圆形
//    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
//    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    lb_point.frame = CGRectMake(x, y, 16.0, 16.0);//圆形大小为10
    lb_point.clipsToBounds = YES;
    [self addSubview:lb_point];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
