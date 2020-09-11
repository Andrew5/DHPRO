//
//  DHTestDropView.m
//  Test
//
//  Created by jabraknight on 2018/12/28.
//  Copyright © 2018 Rillakkuma. All rights reserved.
//

#import "DHTestDropView.h"
@interface DHTestDropView()
@property (nonatomic,strong)UIView *contentViewForDrag;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGRect freeRect;
@property (nonatomic,strong)UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation DHTestDropView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)contentViewForDrag{
	if (_contentViewForDrag==nil) {
		_contentViewForDrag = [[UIView alloc]init];
		_contentViewForDrag.clipsToBounds = YES;
		_contentViewForDrag.frame = (CGRect){CGPointZero,self.bounds.size};
		[self addSubview:self.contentViewForDrag];
	}
	return _contentViewForDrag;
}
-(UIButton *)button{
	if (_button==nil) {
		_button = [[UIButton alloc]init];
		_button.clipsToBounds = YES;
		_button.enabled = NO;
		_button.frame = (CGRect){CGPointZero,self.bounds.size};
		[self.contentViewForDrag addSubview:_button];
	}
	return _button;
}
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self createUI];
	}
	return self;
}
- (void)createUI{
	self.backgroundColor = [UIColor lightGrayColor];
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDragView)];
	[self addGestureRecognizer:singleTap];
	
	
	//添加移动手势可以拖动
	_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
	_panGestureRecognizer.minimumNumberOfTouches = 1;
	_panGestureRecognizer.maximumNumberOfTouches = 1;
	[self addGestureRecognizer:_panGestureRecognizer];
}
-(void)clickDragView{
	
}
- (void)dragAction:(UIPanGestureRecognizer *)pan{
	switch (pan.state) {
		case UIGestureRecognizerStateBegan:
		{
			[pan setTranslation:CGPointMake(0, 0) inView:self];
			//保存触摸起始点位置
			self.startPoint = [pan translationInView:self];
			//该view置于最前
			[[self superview] bringSubviewToFront:self];
			break;
		}
			
		case UIGestureRecognizerStateChanged:
		{
			CGPoint point = [pan translationInView:self];
			float dx;
			float dy;
			dx = point.x - self.startPoint.x;
			dy = point.y - self.startPoint.y;
			CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
			//移动view
			self.center = newcenter;
			//  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
			[pan setTranslation:CGPointMake(0, 0) inView:self];
			break;

		}
		case UIGestureRecognizerStateEnded:
		{
			//中心点判断
			float centerX = self.freeRect.origin.x+(self.freeRect.size.width - self.frame.size.width)/2;
			
			CGRect rect = self.frame;
			if (self.frame.origin.x< centerX) {
				CGContextRef context = UIGraphicsGetCurrentContext();
				[UIView beginAnimations:@"leftMove" context:context];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				[UIView setAnimationDuration:0.5];
				rect.origin.x = self.freeRect.origin.x;
				[self setFrame:rect];
				[UIView commitAnimations];
			}else {
				CGContextRef context = UIGraphicsGetCurrentContext();
				[UIView beginAnimations:@"rightMove" context:context];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				[UIView setAnimationDuration:0.5];
				rect.origin.x =self.freeRect.origin.x+self.freeRect.size.width - self.frame.size.width;
				[self setFrame:rect];
				[UIView commitAnimations];
			}
			break;
		}
			
		default:
			break;
	}
	
}
@end
