#import "UIView+Layout.h"

@implementation UIView (Layout)
- (CGFloat)hb_left {
	return self.frame.origin.x;
}

- (void)setHb_left:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)hb_top {
	return self.frame.origin.y;
}

- (void)setHb_top:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)hb_right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setHb_right:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)hb_bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setHb_bottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)hb_width {
	return self.frame.size.width;
}

- (void)setHb_width:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)hb_height {
	return self.frame.size.height;
}

- (void)setHb_height:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat)hb_centerX {
	return self.center.x;
}

- (void)setHb_centerX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)hb_centerY {
	return self.center.y;
}

- (void)setHb_centerY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)hb_origin {
	return self.frame.origin;
}

- (void)setHb_origin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (CGSize)hb_size {
	return self.frame.size;
}

- (void)setHb_size:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}
- (CGPoint)hb_bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}
-(void)setHb_bottomRight:(CGPoint)hb_bottomRight{
    
}
- (CGPoint)hb_bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}
-(void)setHb_bottomLeft:(CGPoint)hb_bottomLeft{
    
}
- (void)setX:(CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)x
{
	return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (CGFloat)max_X{
    return CGRectGetMaxX(self.frame);
}
- (void)setMax_X:(CGFloat)max_X{}

- (CGFloat)max_Y{
    return CGRectGetMaxY(self.frame);
}
- (void)setMax_Y:(CGFloat)max_Y{}

- (CGFloat)width
{
    return self.frame.size.width;
}
@end
