//
//  UIView+RandomCorner.m
//  RandomCornerDemo
//
//  Created by zzg on 2018/5/9.
//  Copyright © 2018年 Hikvision. All rights reserved.
//

#import "UIView+RandomCorner.h"

@implementation UIView (RandomCorner)

/**
 给view设置圆角
 
 @param corners 圆角位置
 @param cornerRadii 圆角弧度
 */
- (void)setCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    //??:两个cornerRadii宽高不一样会怎样
    //测试结果显示，虽然cornerRadii类型是CGSize但是圆角半径其实取的是size中的width
///TODO:能否做到设置不同的角有不同半径的圆角
    //给self视图添加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
}
//webGL页面的截屏.具体是通过canvas getImageData()方法取得图片数据后返回base64格式的数据，客户端在需要截图的时候，调用这个JS接口获取base64字符串并转换成UIImage
- (UIImage*)imageSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,YES,self.contentScaleFactor);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
