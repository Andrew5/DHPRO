//
//  HDCollectionMonthDetailHeaderView.m
//  FMDB
//
//  Created by 黄定师 on 2018/12/11.
//  Copyright © 2018 黄定师. All rights reserved.
//

#import "HDCollectionMonthDetailHeaderView.h"
#import "Masonry.h"

@implementation HDCollectionMonthDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        [self hd_monthDetailHeaderViewConstraints];
    }
    return self;
}

#pragma mark - constraints
- (void)hd_monthDetailHeaderViewConstraints
{
    [_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}

#pragma mark - getter
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
    }
    return _label;
}

@end
