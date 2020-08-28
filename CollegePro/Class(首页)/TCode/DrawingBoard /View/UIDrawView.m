//
//  UIDrawView.m
//  Draw
//
//  Created by Ibokan on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIDrawView.h"

@implementation UIDrawView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _lineArray = [NSMutableArray array];
        color = [[UIColor alloc] init];
        color = [UIColor redColor];
        UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [undoBtn setTitle:@"undo" forState:UIControlStateNormal];
        undoBtn.frame = CGRectMake(320-100, 20, 100, 30);
        [undoBtn addTarget:self action:@selector(undoDraw) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:undoBtn];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearBtn setTitle:@"clear" forState:UIControlStateNormal];
        clearBtn.frame = CGRectMake(320-100, 60, 100, 30);
        [clearBtn addTarget:self action:@selector(clearDraw) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearBtn];
        
        UIButton *redButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [redButton setTitle:@"红色" forState:UIControlStateNormal];
        redButton.tag = 1000;
        redButton.frame = CGRectMake(20, 450, 50, 30);
        [redButton addTarget:self action:@selector(makeColor:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:redButton];
        
        UIButton *blueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        blueButton.tag = 1001;
        [blueButton setTitle:@"蓝色" forState:UIControlStateNormal];
        blueButton.frame = CGRectMake(80, 450, 50, 30);
        [blueButton addTarget:self action:@selector(makeColor:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:blueButton];
        
        UIButton *blackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        blackButton.tag = 1002;
        [blackButton setTitle:@"黑色" forState:UIControlStateNormal];
        blackButton.frame = CGRectMake(140, 450, 50, 30);
        [blackButton addTarget:self action:@selector(makeColor:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:blackButton];
        
    }
    return self;
}
- (void) makeColor:(UIButton *)sender
{
    if(sender.tag == 1000)
    {
        color = [UIColor redColor];
    }
     if(sender.tag == 1001)
    {
        color = [UIColor blueColor];
    }
    if(sender.tag == 1002)
    {
        color = [UIColor blackColor];
    }
    
}
- (void) clearDraw
{
    [_lineArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void) undoDraw
{
    if([_lineArray count] == 0)
    {
        return;
    }
    [_lineArray removeLastObject];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//重写方法

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(c, color.CGColor);
    CGContextSetLineWidth(c, 2.0);
    
    for(NSMutableArray *touchArray in _lineArray)
    {
        if([touchArray count] == 0)
        {
            continue;
        }
        
        for(int i = 0; i<[touchArray count]-1; i++)
        {
           
            NSValue *v = [touchArray objectAtIndex:i];
            CGPoint prePoint = [v CGPointValue];
            
            NSValue *v2 = [touchArray objectAtIndex:i+1];
            CGPoint currPoint = [v2 CGPointValue];
            
            CGContextMoveToPoint(c, prePoint.x, prePoint.y);
            CGContextAddLineToPoint(c, currPoint.x, currPoint.y);
            //CGContextStrokePath(c);
        }
    }
    CGContextStrokePath(c);
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *touchArray = [NSMutableArray array];
    [_lineArray addObject:touchArray];
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *t = [touches anyObject];
    CGPoint currentPoint = [t locationInView:self];
    NSValue *v = [NSValue valueWithCGPoint:currentPoint];
    NSMutableArray *touchArray = [_lineArray lastObject];
    [touchArray addObject:v];
    
    
    [self setNeedsDisplay];    ///刷新UI调用drawRect方法   刷新UI
    
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}
@end
