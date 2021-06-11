//
//  UIButton+ImageTitleSpacing.m
//  LBFinancial
//
//  Created by Rillakkuma on 2017/12/11.
//  Copyright © 2017年 com.zhongkehuabo.LeBangFinancial. All rights reserved.
//

#import "UIButton+ImageTitleSpacing.h"
#import <objc/runtime.h>

//static char topEdgeKey;
//static char leftEdgeKey;
//static char bottomEdgeKey;
//static char rightEdgeKey;

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
int kTimeout = 60;
dispatch_source_t _timer;
@implementation UIButton (ImageTitleSpacing)
@dynamic normalTitle;
/*
-(void)setEnlargeEdge:(CGFloat)enlargeEdge
{
    [self setEnlargeEdgeWithTop:enlargeEdge left:enlargeEdge bottom:enlargeEdge right:enlargeEdge];
}
-(void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left
                      bottom:(CGFloat)bottom right:(CGFloat)right
{
    objc_setAssociatedObject(self, &topEdgeKey, [NSNumber numberWithFloat:top], 1);
    objc_setAssociatedObject(self, &leftEdgeKey, [NSNumber numberWithFloat:left], 1);
    objc_setAssociatedObject(self, &bottomEdgeKey, [NSNumber numberWithFloat:bottom], 1);
    objc_setAssociatedObject(self, &rightEdgeKey, [NSNumber numberWithFloat:right], 1);
}
-(CGFloat)enlargeEdge
{
    return [(NSNumber *)objc_getAssociatedObject(self, &topEdgeKey) floatValue];
}
-(CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topEdgeKey);
     NSNumber *leftEdge = objc_getAssociatedObject(self, &leftEdgeKey);
     NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomEdgeKey);
     NSNumber *rightEdge = objc_getAssociatedObject(self, &rightEdgeKey);
    if (topEdge && leftEdge && bottomEdge && rightEdge)
    {
        CGRect enlargeRect = CGRectMake(self.bounds.origin.x - leftEdge.floatValue, self.bounds.origin.y - topEdge.floatValue, self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue, self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
        return enlargeRect;
    }
    
    return self.bounds;
}
//hittest确定点击的对象
 -(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.alpha <= 0.01 || !self.userInteractionEnabled || self.hidden)
    {
        return nil;
    }
    CGRect enlargedRect = [self enlargedRect];
    return CGRectContainsPoint(enlargedRect, point)?self:nil;
    
}
*/
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
						imageTitleSpace:(CGFloat)space
{
	// 1. 得到imageView和titleLabel的宽、高
	CGFloat imageWith = self.imageView.frame.size.width;
	CGFloat imageHeight = self.imageView.frame.size.height;
	
	CGFloat labelWidth = 0.0;
	CGFloat labelHeight = 0.0;
	if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
		// 由于iOS8中titleLabel的size为0，用下面的这种设置
		labelWidth = self.titleLabel.intrinsicContentSize.width;
		labelHeight = self.titleLabel.intrinsicContentSize.height;
	} else {
		labelWidth = self.titleLabel.frame.size.width;
		labelHeight = self.titleLabel.frame.size.height;
	}
	
	// 2. 声明全局的imageEdgeInsets和labelEdgeInsets
	UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
	UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
	
	// 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
	switch (style) {
		case MKButtonEdgeInsetsStyleTop:
		{
			imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
			labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
		}
			break;
		case MKButtonEdgeInsetsStyleLeft:
		{
			imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0+15, 0, space/2.0);
			labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0+15, 0, -space/2.0);

		}
			break;
		case MKButtonEdgeInsetsStyleBottom:
		{
			imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
			labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
		}
			break;
		case MKButtonEdgeInsetsStyleRight:
		{
			imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
			labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
		}
			break;
		default:
			break;
	}
	// 4. 赋值
	self.titleEdgeInsets = labelEdgeInsets;
	self.imageEdgeInsets = imageEdgeInsets;
}
- (void)verifedCodeButtonWithEndTime:(NSString *)endTime andEndString:(NSString *)endString {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    
    NSDate *startDate = [NSDate date];
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    
    
    __block int timeout = timeInterval;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.normalTitle = endString;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"orderOutTime" object:nil];
            });
        } else {
            
            int hour = (int)(timeout) / 3600;
            int minute = (int)(timeout - hour * 3600) / 60;
            int seconds = timeout - minute * 60 - hour * 3600;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                
                NSString *strTime = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute,seconds];
                self.normalTitle = strTime;
                
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}




- (void)verifedCodeButtonWithEndTime:(NSString *)endTime instetString:(NSString *)instrtString newTitle:(NSString *)newTitle {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    
    NSDate *startDate = [NSDate date];
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    
    
    __block int timeout = timeInterval;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.normalTitle = newTitle;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"orderOutTime" object:nil];
            });
        } else {
            
            int hour = (int)(timeout) / 3600;
            int minute = (int)(timeout - hour * 3600) / 60;
            int seconds = timeout - minute * 60 - hour * 3600;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                
                NSString *strTime = [NSString stringWithFormat:@"%@ %02d:%02d:%02d",instrtString ,hour, minute,seconds];
                self.normalTitle = strTime;
                
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)verifedCodeButtonWithTitle:(NSString *)title andNewTitle:(NSString *)newTitle bgImageName:(NSString *)imageName newBgImageName:(NSString *)newImageName
{
    __weak __typeof(&*self)weakSelf = self;
    __block int timeout = kTimeout;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (title) {
                    weakSelf.normalTitle = newTitle;
                }
                if (imageName) {
//                    weakSelf.normalBgImage = imageName;
                }
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                
                weakSelf.normalTitle = strTime;
//                if (newTitle) {
//                    weakSelf.normalTitle = [NSString stringWithFormat:@"%@%@s",newTitle, strTime];
//                }
                if (newImageName) {
//                    weakSelf.normalBgImage = newImageName;
                }
                [UIView commitAnimations];
                weakSelf.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)relaseTimer {
    if (!_timer) {
        return;
    }
    dispatch_source_cancel(_timer);
}

- (void)setMulColor:(NSArray <UIColor *>*)colors startPoint:(NSArray <NSNumber *>*)points {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;  // 设置显示的frame
    gradientLayer.colors = colors;  // 设置渐变颜色
    gradientLayer.locations = points;    // 颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)be_setEnlargeEdge:(CGFloat)size {
    
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)be_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)be_enlargedRect {
    
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect rect = [self be_enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}
@end
