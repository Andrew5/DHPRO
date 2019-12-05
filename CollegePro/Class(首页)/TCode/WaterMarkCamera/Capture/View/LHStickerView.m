//
//  LHStickerView.m
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/15.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//


#import "LHStickerView.h"
#import "UIView+AAToolkit.h"
@interface LHStickerView ()

@property (nonatomic) CAShapeLayer *shapeLayer;
@end

@implementation LHStickerView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
    UIImageView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}
- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.fillColor = nil;
        _shapeLayer.path = [UIBezierPath bezierPathWithRect:_imageView.bounds].CGPath;
        _shapeLayer.frame = _imageView.bounds;
        _shapeLayer.lineWidth = 2.f;
        _shapeLayer.lineCap = @"square";
        _shapeLayer.lineDashPattern = @[@10, @10];
    }
    return _shapeLayer;
}
+ (void)setActiveStickerView:(LHStickerView *)view
{
    static LHStickerView *activeView = nil;
    if(view != activeView)
    {
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    int gap = 32;
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+gap, image.size.height+gap)];
    
    if(self)
    {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_deleteButton setImage:[UIImage imageNamed:@"watermark_delete_button"]
                       forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self
                          action:@selector(pushedDeleteBtn:)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.userInteractionEnabled = YES;
        _circleView.image = [UIImage imageNamed:@"watermark_zoom_button"];
        [self addSubview:_circleView];
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDIdPinch:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view = [super hitTest:point withEvent:event];
    
    if(view == self)
    {
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)pushedDeleteBtn:(id)sender
{
    LHStickerView *nextTarget = nil;
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i)
    {
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[LHStickerView class]])
        {
            nextTarget = (LHStickerView *)view;
            break;
        }
    }
    
    if(nextTarget==nil)
    {
        for(NSInteger i=index-1; i>=0; --i)
        {
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[LHStickerView class]])
            {
                nextTarget = (LHStickerView *)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteStickerView:)]) {
        [self.delegate deleteStickerView:self];
    }
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    
    if (active) {
        // 边框虚线
        [_imageView.layer addSublayer:self.shapeLayer];

    }else{
        for (CALayer *layer in _imageView.layer.sublayers) {
            if ([layer isEqual:self.shapeLayer]) {
                [layer removeFromSuperlayer];
            }
        }
    }

}

- (void)setScale:(CGFloat)scaleX andScaleY:(CGFloat)scaleY
{
    _scale = MIN(scaleX, scaleY);
    self.transform = CGAffineTransformIdentity;
    _imageView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.cornerRadius = 3/_scale;
    
    [self stickPanWithRect:self.frame];

}

- (void)setScale:(CGFloat)scale
{
    [self setScale:scale andScaleY:scale];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);

    [self stickPanWithRect:self.frame];
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 0.)];
}
- (void)viewDIdPinch:(UIPinchGestureRecognizer *)pinch
{
    if (pinch.state == UIGestureRecognizerStateEnded) {
        _scale = pinch.scale;
    }else if(pinch.state == UIGestureRecognizerStateBegan && _scale != 0.0f){
        pinch.scale = _scale;
    }
    if (pinch.scale !=NAN && pinch.scale != 0.0) {
        [self setScale:pinch.scale];
    }

}
-(void)handlePinches:(UIPinchGestureRecognizer *)paramSender{
    }
- (void)stickPanWithRect:(CGRect)rect
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerViewOnRect:)]) {
        [self.delegate stickerViewOnRect:rect];
    }
}
@end
