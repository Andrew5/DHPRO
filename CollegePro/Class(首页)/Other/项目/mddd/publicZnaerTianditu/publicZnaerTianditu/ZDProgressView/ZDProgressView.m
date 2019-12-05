//
//  ZDProgressView.m
//  PE
//
//  Created by 杨志达 on 14-6-20.
//  Copyright (c) 2014年 PE. All rights reserved.
//

#import "ZDProgressView.h"

@interface ZDProgressView()

@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UILabel *oneLabel;

@property (nonatomic,strong) UIView *twoView;
@property (nonatomic,strong) UILabel *twoLabel;

@end

@implementation ZDProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zdInit];
        [self zdFrame:frame];

    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self zdFrame:frame];
}

- (void)zdFrame:(CGRect)frame
{
    self.layer.cornerRadius = frame.size.height/2;

    self.oneView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.oneView.layer.cornerRadius = frame.size.height/2;
    self.oneLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.twoView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.twoLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    UIBezierPath *bgPath = [[UIBezierPath alloc] init];
    [bgPath moveToPoint:CGPointMake(frame.size.width - frame.size.height/2, frame.size.height/2)];
    [bgPath addLineToPoint:CGPointMake(frame.size.height/2, frame.size.height/2)];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(frame.size.height/2, frame.size.height/2)];
    [path addLineToPoint:CGPointMake(frame.size.width - frame.size.height/2, frame.size.height/2)];
}

- (void)zdInit
{
    self.borderWidth = 1;

    self.twoView = [[UIView alloc] init];
    self.twoView.clipsToBounds = YES;
    [self addSubview:self.twoView];
    
    self.twoLabel = [[UILabel alloc] init];
    self.twoLabel.textAlignment = NSTextAlignmentCenter;
    self.twoLabel.layer.masksToBounds = YES;
    self.twoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.twoLabel];

    self.oneView = [[UIView alloc] init];
    self.oneView.clipsToBounds = YES;
    [self addSubview:self.oneView];
    
    self.oneLabel = [[UILabel alloc] init];
    self.oneLabel.textAlignment = NSTextAlignmentCenter;
    self.oneLabel.layer.masksToBounds = YES;
    self.oneLabel.layer.cornerRadius = 5;
    self.oneLabel.backgroundColor = [UIColor clearColor];
    [self.oneView addSubview:self.oneLabel];
}

#pragma property set or get
- (void)setNoColor:(UIColor *)noColor
{
    self.oneLabel.textColor = noColor;
    self.twoView.backgroundColor = noColor;
}

- (void)setPrsColor:(UIColor *)prsColor
{
    self.layer.borderColor = prsColor.CGColor;
    self.twoLabel.textColor = prsColor;
    self.oneView.backgroundColor = prsColor;
}

- (void)setProgress:(CGFloat)progress
{
    self.oneView.frame = CGRectMake(0, 0, self.frame.size.width * progress, self.frame.size.height);
}

- (void)setBorderWidth:(NSInteger)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (void)setText:(NSString *)text
{
    self.oneLabel.text = text;
    self.twoLabel.text = text;
}

- (void)setTextFont:(UIFont *)textFont
{
    self.oneLabel.font = textFont;
    self.twoLabel.font = textFont;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
