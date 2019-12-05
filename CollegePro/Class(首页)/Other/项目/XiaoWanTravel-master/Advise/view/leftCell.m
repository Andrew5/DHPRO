//
//  leftCell.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/29.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "leftCell.h"
#import "UIView+Extension.h"
@implementation leftCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    self.color.backgroundColor = [UIColor blueColor];
    self.textLabel.highlightedTextColor = [UIColor colorWithRed:53/255.0f green:123/255.0f blue:240/255.0f alpha:1];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
    self.textLabel.font = [UIFont systemFontOfSize:14];
}

/**
 * 可以在这个方法中监听cell的选中和取消选中
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.color.hidden = !selected;
    self.textLabel.textColor = selected ? self.color.backgroundColor : [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
}


@end
