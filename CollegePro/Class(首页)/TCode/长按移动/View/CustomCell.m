//
//  CustomCell.m
//  UIcollectionV
//
//  Created by BOBO on 16/11/10.
//  Copyright © 2016年 BOBO. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titlesLab];
        [self.contentView addSubview:self.delimgv];
    }

    return self;
}

-(UILabel *)titlesLab
{
    if (!_titlesLab) {
        _titlesLab = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width*0.1, self.contentView.frame.size.height*0.845, self.contentView.frame.size.width*0.8, self.contentView.frame.size.height*0.15)];
        _titlesLab.textAlignment = NSTextAlignmentCenter;
//        _titlesLab.font = Font12;
        _titlesLab.textColor = [UIColor  blackColor];
        
    }
    return _titlesLab;
}

-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width*0.235, self.contentView.frame.size.height*0.1, 45,45/*self.contentView.frame.size.width*0.53, self.contentView.frame.size.height*0.5*/)];
    }
    return _iconView;
}

-(UIImageView *)delimgv
{
    if (!_delimgv) {
        _delimgv = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-30, 0, 15, 15)];
    }
    return _delimgv;
}
@end
