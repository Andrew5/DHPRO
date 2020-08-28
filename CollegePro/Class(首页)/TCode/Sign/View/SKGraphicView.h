//
//  SKGraphicView.h
//  SKDrawingBoard
//
//  Created by youngxiansen on 15/10/10.
//  Copyright © 2015年 youngxiansen. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  画布
 */
@interface SKGraphicView : UIView
{
    CGPoint _start;
    CGPoint _move;
    CGMutablePathRef _path;
    NSMutableArray *_pathArray;
    CGFloat _lineWidth;
    UIColor *_color;
}
@property (nonatomic,assign)CGFloat lineWidth;/**< 线宽 */
@property (nonatomic,strong)UIColor *color;/**< 线的颜色 */
@property (nonatomic,strong)NSMutableArray *pathArray;

-(UIImage*)getDrawingImg;

@end
