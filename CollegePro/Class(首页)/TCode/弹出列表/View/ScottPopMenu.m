//
//  ScottPopMenu.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/5.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottPopMenu.h"

#define kArrowHeight    10.0
#define kArrowWidth     15.0
#define kButtonHeight   44.0
#define kCornerRadius   5.0

#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width


@interface UIView (ScottFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@end

@implementation UIView (ScottFrame)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end

@interface ScottPopMenu ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *icons;

@property (nonatomic, assign) CGFloat arrowHeight;
@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, assign) CGFloat buttonHeight;

@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, strong) UIColor *seperatorColor;

@property (nonatomic, assign) CGFloat arrowPosition;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGPoint anchorPoint;

@property (nonatomic, assign) CGPoint touchPoint;


@end

// ---------------------------  custom cell ----------------------
@interface ScottPopMenuCell : UITableViewCell

@property (nonatomic, assign, getter=isShowSeperator) BOOL showSeperator;
@property (nonatomic, strong) UIColor *seperatorColor;


@end

@implementation ScottPopMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _showSeperator = YES;
        _seperatorColor = [UIColor lightGrayColor];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setShowSeperator:(BOOL)showSeperator {
    _showSeperator = showSeperator;
    [self setNeedsDisplay];
}

- (void)setSeperatorColor:(UIColor *)seperatorColor {
    _seperatorColor = seperatorColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.isShowSeperator) return;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5)];
    [_seperatorColor setFill];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:1];
    [bezierPath closePath];
}


@end




// -----------------------------  ScottPopMenu -------------------------

@implementation ScottPopMenu

- (instancetype)initWithTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth delegate:(id<ScottPopMenuDelegate>)delegate {
    if (self = [super init]) {
        [self configPropertysWithTitles:titles icons:icons menuWidth:menuWidth delegate:delegate];
    }
    return self;
}

// 初始化
- (void)configPropertysWithTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth delegate:(id<ScottPopMenuDelegate>)delegate {
    
    _arrowHeight = kArrowHeight;
    _arrowWidth = kArrowWidth;
    _buttomHeight = kButtonHeight;
    _cornerRadius = kCornerRadius;
    
    _titles = titles;
    _icons  = icons;
    
    _dismissOnSelect = YES;
    _dismissOnTapOutside = YES;
    _translucent = YES;
    
    _textFontSize = 15.0;
    
    _textColor = [UIColor blackColor];
    
    _offset = 0.0;
    
    _popMenuType = ScottPopMenuTypeDefault;
    
    _contentColor = [UIColor whiteColor];
    _seperatorColor = [UIColor lightGrayColor];
    
    if (delegate) self.delegate = delegate;
    
    self.width = menuWidth;
    self.height = MIN(5 * _buttomHeight, titles.count * _buttomHeight) + 2 * _arrowHeight;
    
    _arrowPosition = 0.5 * self.width - 0.5 * _arrowWidth;
    
    self.alpha = 0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2.0;
    
    _mainView = [[UIView alloc] initWithFrame: self.bounds];
    _mainView.backgroundColor = _contentColor;
    _mainView.layer.cornerRadius = _cornerRadius;
    _mainView.layer.masksToBounds = YES;
    
    _contentView = [[UITableView alloc] initWithFrame: _mainView.bounds style:UITableViewStylePlain];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.delegate = self;
    _contentView.dataSource= self;
    _contentView.bounces = titles.count > 5 ? YES : NO;
    _contentView.tableFooterView = [UIView new];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.height -= 2 * _arrowHeight;
    _contentView.centerY = _mainView.centerY;
    
    [_mainView addSubview: _contentView];
    [self addSubview: _mainView];
    
    _bgView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _bgView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismiss)];
    [_bgView addGestureRecognizer: tap];
}


+ (instancetype)popMenuAtPoint:(CGPoint)point withTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth delegate:(id<ScottPopMenuDelegate>)delegate {
    ScottPopMenu *popMenu = [[ScottPopMenu alloc] initWithTitles:titles icons:icons menuWidth:menuWidth delegate:delegate];
    popMenu.touchPoint = point;
    [popMenu showAtPoint:point];
    return popMenu;
}

+ (instancetype)popMenuRelyOnView:(UIView *)relyView withTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth delegate:(id<ScottPopMenuDelegate>)delegate {
    ScottPopMenu *popMenu = [[ScottPopMenu alloc] initWithTitles:titles icons:icons menuWidth:menuWidth delegate:delegate];
    [popMenu showMenuOnView:relyView];
    return popMenu;
}

- (void)showAtPoint:(CGPoint)point {
    _mainView.layer.mask = [self getMaskLayerWithPoint:point];
    [self show];
}

- (CAShapeLayer *)getMaskLayerWithPoint:(CGPoint)point {
    
    
    [self setArrowWithPoint:point];
    
    CAShapeLayer *layer = [self drawMaskLayer];
    [self determineAnchorPoint];
    if (CGRectGetMaxY(self.frame) > kScreenHeight) {
        _arrowPosition = self.width - _arrowPosition - _arrowWidth;
        layer = [self drawMaskLayer];
        layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        self.y = _anchorPoint.y - self.height;
    }
    self.y += self.y >= _anchorPoint.y ? _offset : -_offset;
    return layer;
}

- (CAShapeLayer *)drawMaskLayer {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _mainView.bounds;
    
    CGPoint topRightArcCenter = CGPointMake(self.width-_cornerRadius, _arrowHeight+_cornerRadius);
    CGPoint topLeftArcCenter = CGPointMake(_cornerRadius, _arrowHeight+_cornerRadius);
    CGPoint bottomRightArcCenter = CGPointMake(self.width-_cornerRadius, self.height - _arrowHeight - _cornerRadius);
    CGPoint bottomLeftArcCenter = CGPointMake(_cornerRadius, self.height - _arrowHeight - _cornerRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, _arrowHeight+_cornerRadius)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: _cornerRadius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width-_cornerRadius, self.height - _arrowHeight)];
    [path addArcWithCenter: bottomRightArcCenter radius: _cornerRadius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width, _arrowHeight+_cornerRadius)];
    [path addArcWithCenter: topRightArcCenter radius: _cornerRadius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(_arrowPosition+_arrowWidth, _arrowHeight)];
    [path addLineToPoint: CGPointMake(_arrowPosition+0.5*_arrowWidth, 0)];
    [path addLineToPoint: CGPointMake(_arrowPosition, _arrowHeight)];
    [path addLineToPoint: CGPointMake(_cornerRadius, _arrowHeight)];
    [path addArcWithCenter: topLeftArcCenter radius: _cornerRadius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    [path closePath];
    
    maskLayer.path = path.CGPath;
    
    return maskLayer;

}

- (void)determineAnchorPoint {
    CGPoint aPoint = CGPointMake(0.5, 0.5);
    if (CGRectGetMaxY(self.frame) > kScreenHeight) {
        aPoint = CGPointMake(fabs(_arrowPosition) / self.width, 1);
    }else {
        aPoint = CGPointMake(fabs(_arrowPosition) / self.width, 0);
    }
    [self setAnimationAnchorPoint:aPoint];
}

- (void)setAnimationAnchorPoint:(CGPoint)point {
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}



- (void)setArrowWithPoint:(CGPoint)point {
    _anchorPoint = point;
    
    self.x = point.x - _arrowPosition - 0.5 * _arrowWidth;
    
    self.y = point.y;
    
    CGFloat maxX = CGRectGetMaxX(self.frame);
    CGFloat minX = CGRectGetMinX(self.frame);
    
    if (maxX > kScreenWidth - 10) {
        self.x = kScreenWidth - 10 - self.width;
    }else if (minX < 10) {
        self.x = 10;
    }
    
    maxX = CGRectGetMaxX(self.frame);
    minX = CGRectGetMinX(self.frame);
    
    if ((point.x <= maxX - _cornerRadius) && point.x >= minX + _cornerRadius) {
        _arrowPosition = point.x - minX - 0.5 * _arrowWidth;
    }else if(point.x < minX + _cornerRadius){
        _arrowPosition = _cornerRadius;
    }else{
        _arrowPosition = self.width - _cornerRadius - _arrowWidth;
    }
}

- (void)showMenuOnView:(UIView *)relyView {
    CGRect absoluteRect = [relyView convertRect:relyView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    _mainView.layer.mask = [self getMaskLayerWithPoint:relyPoint];
    if (self.y < _anchorPoint.y) {
        self.y -= absoluteRect.size.height;
    }
    [self show];
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_bgView];
    [keyWindow addSubview:self];
    
    ScottPopMenuCell *cell = [self getLastVisibleCell];
    cell.showSeperator = NO;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        _bgView.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.delegate = nil;
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

- (ScottPopMenuCell *)getLastVisibleCell {
    NSArray <NSIndexPath *>*indexPaths = [_contentView indexPathsForVisibleRows];
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.row < obj2.row;
    }];
    NSIndexPath *indexPath = indexPaths.firstObject;
    return [_contentView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"ScottPopMenu";
    ScottPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ScottPopMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = _textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:_textFontSize];
    cell.textLabel.text = _titles[indexPath.row];
    cell.seperatorColor = _seperatorColor;
    if (_icons.count >= indexPath.row + 1) {
        if ([_icons[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.imageView.image = [UIImage imageNamed:_icons[indexPath.row]];
        }else if ([_icons[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.imageView.image = _icons[indexPath.row];
        }else {
            cell.imageView.image = nil;
        }
    }else {
        cell.imageView.image = nil;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnSelect) [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(popMenu:didSelectRowAtIndexPath:)]){
        [self.delegate popMenu:self didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    ScottPopMenuCell *cell = [self getLastVisibleCell];
    cell.showSeperator = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ScottPopMenuCell *cell = [self getLastVisibleCell];
    cell.showSeperator = NO;
}


#pragma mark - setter
- (void)setPopMenuType:(ScottPopMenuType)popMenuType {
    _popMenuType = popMenuType;
    switch (popMenuType) {
        case ScottPopMenuTypeDark:{
            _textColor = [UIColor lightGrayColor];
            _contentColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.29 alpha:1];
            _seperatorColor = [UIColor lightGrayColor];
        }
            break;
            
        default: {
            _textColor = [UIColor blackColor];
            _contentColor = [UIColor whiteColor];
            _seperatorColor = [UIColor lightGrayColor];
        }
            break;
    }
    
    _mainView.backgroundColor = _contentColor;
    [_contentView reloadData];
}

- (void)setTextFontSize:(CGFloat)textFontSize {
    _textFontSize = textFontSize;
    [_contentView reloadData];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [_contentView reloadData];
}

- (void)setDismissOnTapOutside:(BOOL)dismissOnTapOutside {
    _dismissOnTapOutside = dismissOnTapOutside;
    
    if (!dismissOnTapOutside) {
        for (UIGestureRecognizer *gesture in _bgView.gestureRecognizers) {
            [_bgView removeGestureRecognizer:gesture];
        }
    }
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    if (offset < 0) {
        offset = 0.0;
    }
    self.y += self.y >= _anchorPoint.y ? offset : -offset;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    
    _mainView.layer.mask = [self drawMaskLayer];
    if (self.y < _anchorPoint.y) {
        _mainView.layer.mask.affineTransform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)setShowShadow:(BOOL)showShadow {
    _showShadow = showShadow;
    
    if (!showShadow) {
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowRadius = 0.0;
    }
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    if (self.touchPoint.x == 0 && self.touchPoint.y == 0) {
        return;
    }
    
    if (_translucent == YES) {
        [self showAtPoint:self.touchPoint];
    }else{
        CGPoint tmpPoint = self.touchPoint;
        tmpPoint.y = tmpPoint.y + 64;
        [self showAtPoint:tmpPoint];
    }
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end
