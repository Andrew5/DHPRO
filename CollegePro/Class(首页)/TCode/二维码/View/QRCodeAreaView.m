//
//  QRCodeAreaView.m
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import "QRCodeAreaView.h"
#import "UIViewExt.h"

@interface QRCodeAreaView()

/**
 *  记录当前线条绘制的位置
 */
@property (nonatomic,assign) CGPoint position;

/**
 *  定时器
 */
@property (nonatomic,strong)NSTimer  *timer;

@end

@implementation QRCodeAreaView

- (void)drawRect:(CGRect)rect {
    CGPoint newPosition = self.position;
    newPosition.y += 1;
    
    //判断y到达底部，从新开始下降
    if (newPosition.y > rect.size.height) {
        newPosition.y = 0;
    }
    
    //重新赋值position
    self.position = newPosition;
    
    // 绘制图片
    UIImage *image = [UIImage imageNamed:@"line"];
    
    [image drawAtPoint:self.position];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *areaView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"frame_icon"]];
        areaView.width = self.width;
        areaView.height = self.height;
        [self addSubview:areaView];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)startAnimaion{
    [self.timer setFireDate:[NSDate date]];
}

-(void)stopAnimaion{
    [self.timer setFireDate:[NSDate distantFuture]];
}

@end
