//
//  SKGraphicView.m
//  SKDrawingBoard
//
//  Created by youngxiansen on 15/10/10.
//  Copyright © 2015年 youngxiansen. All rights reserved.
//

#import "SKGraphicView.h"

@implementation SKGraphicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _move = CGPointMake(0, 0);
        _start = CGPointMake(0, 0);
        _lineWidth = 2;
        _color = [UIColor redColor];
        _pathArray = [NSMutableArray array];
        
        //创建保存功能
        UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
        but.frame = CGRectMake(0, self.bounds.size.height-60, 100, 60);
        [but setTitle:@"保存至相册" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        
        
        UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        undoBtn.frame = CGRectMake(110, self.bounds.size.height-60, 100, 60);
        [undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
        [undoBtn addTarget:self action:@selector(undoBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:undoBtn];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        clearBtn.frame = CGRectMake(220, self.bounds.size.height-60, 100, 60);
        [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearBtn];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPicture:context]; //画图
}

- (void)drawPicture:(CGContextRef)context {
    
    
    for (NSArray * attribute in _pathArray) {
        //将路径添加到上下文中
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _path = CGPathCreateMutable(); //创建路径
    
    NSArray *attributeArry = @[(__bridge id)(_path),_color,[NSNumber numberWithFloat:_lineWidth]];
    
    [_pathArray addObject:attributeArry]; //路径及属性数组数组
    _start = [touch locationInView:self]; //起始点
    CGPathMoveToPoint(_path, NULL,_start.x, _start.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    释放路径
    CGPathRelease(_path);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    
    [self setNeedsDisplay];
    
}

#pragma mark --点击事件--

- (void)savePhoto {
    
    if (_pathArray.count) {
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        [self.layer renderInContext:context];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    }
    else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"请您先绘制图形" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        
    }
}

-(UIImage *)getDrawingImg{
    if (_pathArray.count) {
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        [self.layer renderInContext:context];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

        return image;
    }
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"请您先绘制图形" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    return nil;
}


-(void)undoBtnEvent
{
    [_pathArray removeLastObject];
    [self setNeedsDisplay];
}

-(void)clearBtnEvent
{
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}

@end
