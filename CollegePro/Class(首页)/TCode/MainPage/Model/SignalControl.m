//
//  SignalControl.m
//  JHLivePlayLibrary
//
//  Created by xianjunwang on 2017/12/13.
//  Copyright © 2017年 pk. All rights reserved.
//

#import "SignalControl.h"

@implementation SignalControl

#pragma mark  ----  生命周期函数

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andData:(NSString *)data{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.aboveLabel];
        self.aboveLabel.frame = CGRectMake(0, 0, frame.size.width, 14);
        if (title) {
            
            self.aboveLabel.text = title;
        }
        else{
        
            self.aboveLabel.text = @"";
        }
        
        [self addSubview:self.belowLabel];
        self.belowLabel.frame = CGRectMake(0, CGRectGetMaxY(self.aboveLabel.frame) + 14, frame.size.width, 14);
        if (data) {
            
            self.belowLabel.text = data;
        }
        else{
            
            self.belowLabel.text = @"";
        }
        
    }
    return self;
}


#pragma mark  ----  自定义函数
+(float)viewWidthWithStr:(NSString *)title{
    
    float width = 0;
    if (title && title.length > 0) {
    
        float forthWidth = 200;
        width += forthWidth;
    }
    return width;
}


#pragma mark  ----  懒加载


-(UILabel *)aboveLabel{
    
    if (!_aboveLabel) {
        
        _aboveLabel = [[UILabel alloc] init];
        _aboveLabel.font = kFont(14);
        _aboveLabel.textColor = [UIColor blueColor];
        _aboveLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _aboveLabel;
}

-(UILabel *)belowLabel{
    
    if (!_belowLabel) {
        
        _belowLabel = [[UILabel alloc] init];
        _belowLabel.font =  kFont(14);;
        _belowLabel.textColor = [UIColor blueColor];
        _belowLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _belowLabel;
}

@end
