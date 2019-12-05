//
//  ZQVariableMenuCell.m
//  ZQVariableMenuDemo
//
//  Created by 肖兆强 on 2017/12/1.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQVariableMenuCell.h"

@interface ZQVariableMenuCell ()
{
    UILabel *_textLabel;
    UIImageView *_iconImage;
    CAShapeLayer *_borderLayer;
}
@end


@implementation ZQVariableMenuCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = true;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [self backgroundColor];
    
    _iconImage = [[UIImageView alloc] init];
  
    [self addSubview:_iconImage];
    
    
    
    _textLabel = [[UILabel alloc] init];
   
    [self addSubview:_textLabel];
    _textLabel.font = [UIFont systemFontOfSize:12];
    _textLabel.textColor = [self textColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat iconImageH = self.bounds.size.width;
    CGFloat iconImageW =self.bounds.size.width;
    CGFloat iconImageX = 0;
    _iconImage.frame = CGRectMake(iconImageX, 0, iconImageW, iconImageH);
    _iconImage.layer.cornerRadius = iconImageH/2;
    _iconImage.clipsToBounds = YES;
    CGFloat TitleLabelY = self.bounds.size.width +10;
     _textLabel.frame = CGRectMake(0, TitleLabelY, self.bounds.size.width, self.bounds.size.height - TitleLabelY);
    
}


#pragma mark 配置方法

-(UIColor*)backgroundColor{
    return [UIColor clearColor];
}

-(UIColor*)textColor{
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

-(UIColor*)lightTextColor{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
}





#pragma mark -
#pragma mark Setter

-(void)setTitle:(NSString *)title
{
    _title = title;
    _textLabel.text = title;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    _iconImage.image = [UIImage imageNamed:imageName];
    
}





-(void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
        _borderLayer.hidden = false;
    }else{
        self.backgroundColor = [self backgroundColor];
        _borderLayer.hidden = true;
    }
}

-(void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
    if (isFixed) {
        _textLabel.textColor = [self lightTextColor];
    }else{
        _textLabel.textColor = [self textColor];
    }
}


@end
