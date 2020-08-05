//
//  TodayItemCell.m
//  CollegeProExtension
//
//  Created by jabraknight on 2019/6/15.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "TodayItemCell.h"

@implementation TodayItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.labelTitleName];
        [self addSubview:self.imageViewMy];
        
        // 布局子视图
        [self mas_layoutSubviews];
    }
    return self;
}
- (void)mas_layoutSubviews{
    self.imageViewMy.frame = CGRectMake(15, 10, 50, 50);
    self.labelTitleName.frame = CGRectMake(self.imageViewMy.frame.origin.x+self.imageViewMy.frame.size.width + 10 , self.imageViewMy.center.y-10, 145, 20);
}
- (void)setModel:(TodayItemModel *)model{
    _model = model;
    _labelTitleName.text = [model.titlename stringByAppendingString:@"69.6像素"];
    [_imageViewMy setImage:[UIImage imageNamed:model.icon]];
}
#pragma mark - lazy load
- (UIImageView *)imageViewMy {
    if (!_imageViewMy) {
        _imageViewMy = [[UIImageView alloc]init];
        _imageViewMy.image = [UIImage imageNamed:@"精灵球"];
        _imageViewMy.layer.cornerRadius = 8.0;
        _imageViewMy.layer.borderColor = [UIColor redColor].CGColor;
        _imageViewMy.layer.borderWidth = 1.0;
        _imageViewMy.layer.masksToBounds = YES;
    }
    return _imageViewMy;
}

- (UILabel *)labelTitleName {
    if (!_labelTitleName) {
        _labelTitleName = [[UILabel alloc]init];
        _labelTitleName.text = @"精灵球";
    }
    return _labelTitleName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
