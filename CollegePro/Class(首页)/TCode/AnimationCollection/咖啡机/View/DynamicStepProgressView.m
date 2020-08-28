//
//  DynamicStepProgressView.m
//  Test
//
//  Created by Rillakkuma on 2018/1/25.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "DynamicStepProgressView.h"
@interface DynamicStepProgressView() <CAAnimationDelegate>

@property(nonatomic,strong)CAShapeLayer *arcLayer1;
@property(nonatomic,strong)CAShapeLayer *arcLayer2;

@property (nonatomic ,assign)NSInteger targetNum;
@property (nonatomic,assign)CGFloat progressNum;

@end
@implementation DynamicStepProgressView
- (instancetype)initWithFrame:(CGRect)frame targetNumber:(NSInteger)targetNumber
{
	self = [super initWithFrame:frame];
	if (self) {
		_targetNum = targetNumber;
		[self setBackgroundColor:[UIColor clearColor]];
		[self setProgress:0];
	}
	return self;
}

- (void)setProgress:(CGFloat)progress
{
	if (progress <0) {
		progress = 0;
	}
	if (progress >self.targetNum) {
		progress = self.targetNum;
	}
	self.progressNum = progress;
	
	[self drawGrayStepProgress];
	[self drawBlueStepProgress];
}

// 蓝色
- (void)drawBlueStepProgress
{
	NSInteger targetNum =self.targetNum;
	CGFloat progressNum =self.progressNum;
	
	// 线宽
	CGFloat lineWidth =3.0f;
	// 圆的半径
	CGFloat circleRadius = (self.bounds.size.height - lineWidth * 2.0) / 2.0;
	// 节点间线段距离
	CGFloat distanceBetweenTwoPoints = (self.bounds.size.width - circleRadius * targetNum * 2) / (targetNum -1);
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	for (NSInteger i =0; i < progressNum; i ++) {
		// 画圈
		[path addArcWithCenter:CGPointMake(circleRadius + (distanceBetweenTwoPoints + circleRadius *2) * i, circleRadius) radius:circleRadius startAngle:M_PI endAngle:4 *M_PI clockwise:YES];
		
		// 画直线
		[path addLineToPoint:CGPointMake(circleRadius *2 + (distanceBetweenTwoPoints + circleRadius *2) * i, circleRadius)];
		_arcLayer1 = [CAShapeLayer layer];
		_arcLayer1.path = path.CGPath;
		_arcLayer1.lineWidth = lineWidth;
		_arcLayer1.frame =self.bounds;
		_arcLayer1.fillColor = [UIColor clearColor].CGColor;
		_arcLayer1.strokeColor = [UIColor greenColor].CGColor;
		[self.layer addSublayer:_arcLayer1];
		[self drawLineAnimation1:_arcLayer1];
	}
}

// 灰色
- (void)drawGrayStepProgress
{
	NSInteger targetNum =self.targetNum;
	CGFloat progressNum =self.progressNum;
	
	// 线宽
	CGFloat lineWidth =3.0f;
	// 圆的半径
	CGFloat circleRadius = (self.bounds.size.height - lineWidth * 2.0) / 2.0;
	// 节点间线段距离
	CGFloat distanceBetweenTwoPoints = (self.bounds.size.width - circleRadius * targetNum * 2) / (targetNum -1);
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	for (NSInteger i =0; i < targetNum; i ++) {
		// 画圈
		[path addArcWithCenter:CGPointMake(circleRadius + (distanceBetweenTwoPoints + circleRadius *2) * i, circleRadius) radius:circleRadius  startAngle:M_PI endAngle:4 *M_PI clockwise:YES];
		
		// 画直线
		[path addLineToPoint:CGPointMake(circleRadius *2 + (distanceBetweenTwoPoints + circleRadius *2) * i, circleRadius)];
		if (i >= progressNum) {
			_arcLayer2 = [CAShapeLayer layer];
			_arcLayer2.path = path.CGPath;
			_arcLayer2.lineWidth = lineWidth;
			_arcLayer2.frame =self.bounds;
			_arcLayer2.fillColor = [UIColor clearColor].CGColor;
			_arcLayer2.strokeColor = [UIColor grayColor].CGColor;
			[self.layer addSublayer:_arcLayer2];
			[self drawLineAnimation2:_arcLayer2];
		}
	}
}

-(void)drawLineAnimation1:(CAShapeLayer *)layer
{
	CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	basic.duration =self.progressNum;
	basic.delegate =self;
	basic.fromValue = [NSNumber numberWithInteger:0];
	basic.toValue = [NSNumber numberWithInteger:1];
	[layer addAnimation:basic forKey:@""];
}

-(void)drawLineAnimation2:(CAShapeLayer *)layer
{
	CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	basic.duration =0;
	basic.delegate =self;
	[layer addAnimation:basic forKey:@""];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
