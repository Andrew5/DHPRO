//
//  HDMonthDetailCollectionViewCell.m
//  FMDB
//
//  Created by 黄定师 on 2018/12/11.
//  Copyright © 2018 黄定师. All rights reserved.
//

#import "HDMonthDetailCollectionViewCell.h"
#import "Masonry.h"

@interface HDMonthDetailCollectionViewCell ()

@end

@implementation HDMonthDetailCollectionViewCell

@synthesize topLabel = _topLabel;
@synthesize bottomLabel = _bottomLabel;

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.bottomLabel];
        [self hd_monthDetailCollectionViewCellConstraints];
    }
    return self;
}

#pragma mark - constraints
- (void)hd_monthDetailCollectionViewCellConstraints
{
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.bottom.equalTo(_bottomLabel.mas_top);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(30.0);
    }];
}

#pragma mark - getter
- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.backgroundColor = [UIColor lightGrayColor];
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.backgroundColor = [UIColor lightGrayColor];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

@end
