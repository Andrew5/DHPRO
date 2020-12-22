//
//  CustomerFootIdentificationView.m
//  SpeedAcquisitionloan
//
//  Created by Uwaysoft on 2018/6/15.
//  Copyright © 2018年 Lee. All rights reserved.
//
//屏幕的宽和高
#define SCREENWIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#import "CustomerFootIdentificationView.h"
#import "UIView+Layout.h"

@implementation CustomerFootIdentificationView

- (void)footViewWithlineWidth:(CGFloat)width lineWithOriginY:(CGFloat)Y titleWithStr:(NSString *)title{
    CGFloat X = 0.0;
    CGFloat titleWidth = [self autoSizeWithText:title Font:kFont(12)].width;
    CGFloat titleHeight = [self autoSizeWithText:title Font:kFont(12)].height;
    X = (SCREENWIDTH-titleWidth)/2-width-10;
    //左边的横线
    UILabel *lb_left = [[UILabel alloc]init];
    lb_left.backgroundColor = [UIColor lightGrayColor];
    lb_left.alpha = 0.7;
    lb_left.frame = CGRectMake(X, Y, width, 1);
    [self addSubview:lb_left];
    
    //文字
    UILabel *lb_space = [[UILabel alloc]initWithFrame:CGRectMake(lb_left.hb_right+10, Y-titleHeight/2, titleWidth, 20)];
    lb_space.text = title;
    lb_space.font = kFont(12);
    lb_space.textAlignment = NSTextAlignmentCenter;
    [lb_space setTextColor:[UIColor lightGrayColor]];
    [self addSubview:lb_space];
    
    //右边的横线
    UILabel *lb_right = [[UILabel alloc]init];
    lb_right.backgroundColor = [UIColor lightGrayColor];
    lb_right.alpha = 0.7;
    lb_right.frame = CGRectMake(lb_space.hb_right+10, lb_left.hb_top+1, width, 0.5);
    [self addSubview:lb_right];
}
- (CGSize)autoSizeWithText:(NSString *)str Font:(UIFont *)font{
    CGSize size_textfont = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    return size_textfont;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
