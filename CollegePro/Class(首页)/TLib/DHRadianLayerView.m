//
//  DHRadianLayerView.m
//  B
//
//  Created by jabraknight on 2019/9/26.
//  Copyright © 2019 jabraknight. All rights reserved.
//

#import "DHRadianLayerView.h"
//https://www.jianshu.com/p/e6a3d83a5be6
/*
 RadianLayerView.radian = 10;
 RadianLayerView.direction = 1;
 等效于下面的方法
 RadianLayerView.transform = CGAffineTransformMakeRotation(M_PI);
 */
@implementation DHRadianLayerView
/*
 过两点的圆, 圆心在两点连线的垂直平分线上
 ∠de = ∠bc
 c^2 = a^2 + b^2
 sin_bc = a / c;
 
 a： 底部弧度的高度
 b： view宽度的一半
 Sin(de) = Sin(bc) = (c / 2) / d
 
 以上可以算出半径：
 d = c / ( sin_bc * 2)
 
 右侧蓝点为起点, 左侧蓝点为终点
 蓝点距圆心水平线高度为：
 s1 = d - a
 可得出起点弧度为：
 rs = asin((s1) / d);
 终点弧度为：
 re = M_PI - rs
 */
- (void)setRadian:(CGFloat) radian
{
    if(radian == 0) return;
    CGFloat t_width = CGRectGetWidth(self.frame); // 宽
    CGFloat t_height = CGRectGetHeight(self.frame); // 高
    CGFloat height = fabs(radian); // 圆弧高度
    CGFloat x = 0;
    CGFloat y = 0;
    
    // 计算圆弧的最大高度
    CGFloat _maxRadian = 0;
    switch (self.direction) {
        case DXRadianDirectionBottom:
        case DXRadianDirectionTop:
            _maxRadian =  MIN(t_height, t_width / 2);
            break;
        case DXRadianDirectionLeft:
        case DXRadianDirectionRight:
            _maxRadian =  MIN(t_height / 2, t_width);
            break;
        default:
            break;
    }
    if(height > _maxRadian){
        NSLog(@"圆弧半径过大, 跳过设置。");
        return;
    }
    
    // 计算半径
    CGFloat radius = 0;
    switch (self.direction) {
        case DXRadianDirectionBottom:
        case DXRadianDirectionTop:
        {
            CGFloat c = sqrt(pow(t_width / 2, 2) + pow(height, 2));
            CGFloat sin_bc = height / c;
            radius = c / ( sin_bc * 2);
        }
            break;
        case DXRadianDirectionLeft:
        case DXRadianDirectionRight:
        {
            CGFloat c = sqrt(pow(t_height / 2, 2) + pow(height, 2));
            CGFloat sin_bc = height / c;
            radius = c / ( sin_bc * 2);
        }
            break;
        default:
            break;
    }
    
    // 画圆
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.direction) {
        case DXRadianDirectionBottom:
        {
            if(radian > 0){
                CGPathMoveToPoint(path,NULL, t_width,t_height - height);
                CGPathAddArc(path,NULL, t_width / 2, t_height - radius, radius, asin((radius - height ) / radius), M_PI - asin((radius - height ) / radius), NO);
            }else{
                CGPathMoveToPoint(path,NULL, t_width,t_height);
                CGPathAddArc(path,NULL, t_width / 2, t_height + radius - height, radius, 2 * M_PI - asin((radius - height ) / radius), M_PI + asin((radius - height ) / radius), YES);
            }
            CGPathAddLineToPoint(path,NULL, x, y);
            CGPathAddLineToPoint(path,NULL, t_width, y);
        }
            break;
        case DXRadianDirectionTop:
        {
            if(radian > 0){
                CGPathMoveToPoint(path,NULL, t_width, height);
                CGPathAddArc(path,NULL, t_width / 2, radius, radius, 2 * M_PI - asin((radius - height ) / radius), M_PI + asin((radius - height ) / radius), YES);
            }else{
                CGPathMoveToPoint(path,NULL, t_width, y);
                CGPathAddArc(path,NULL, t_width / 2, height - radius, radius, asin((radius - height ) / radius), M_PI - asin((radius - height ) / radius), NO);
            }
            CGPathAddLineToPoint(path,NULL, x, t_height);
            CGPathAddLineToPoint(path,NULL, t_width, t_height);
        }
            break;
        case DXRadianDirectionLeft:
        {
            if(radian > 0){
                CGPathMoveToPoint(path,NULL, height, y);
                CGPathAddArc(path,NULL, radius, t_height / 2, radius, M_PI + asin((radius - height ) / radius), M_PI - asin((radius - height ) / radius), YES);
            }else{
                CGPathMoveToPoint(path,NULL, x, y);
                CGPathAddArc(path,NULL, height - radius, t_height / 2, radius, 2 * M_PI - asin((radius - height ) / radius), asin((radius - height ) / radius), NO);
            }
            CGPathAddLineToPoint(path,NULL, t_width, t_height);
            CGPathAddLineToPoint(path,NULL, t_width, y);
        }
            break;
        case DXRadianDirectionRight:
        {
            if(radian > 0){
                CGPathMoveToPoint(path,NULL, t_width - height, y);
                CGPathAddArc(path,NULL, t_width - radius, t_height / 2, radius, 1.5 * M_PI + asin((radius - height ) / radius), M_PI / 2 + asin((radius - height ) / radius), NO);
            }else{
                CGPathMoveToPoint(path,NULL, t_width, y);
                CGPathAddArc(path,NULL, t_width  + radius - height, t_height / 2, radius, M_PI + asin((radius - height ) / radius), M_PI - asin((radius - height ) / radius), YES);
            }
            CGPathAddLineToPoint(path,NULL, x, t_height);
            CGPathAddLineToPoint(path,NULL, x, y);
        }
            break;
        default:
            break;
    }
    
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    self.layer.mask = shapeLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
