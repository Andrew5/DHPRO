//
//  WKLifeCircleRecordCell.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/22.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKLifeCircleRecordCell.h"
#import "WKVCLifeCircleRecordManager.h"
#import "WKHeader.h"
@interface WKLifeCircleRecordCell ()
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *subTitleLabel;
@property (strong, nonatomic)  UILabel *detailLabel;
@end

@implementation WKLifeCircleRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return  self;
}

- (void)configUI
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.detailLabel];
    self.titleLabel.frame = CGRectMake(8, 8, 120, 20);
    self.subTitleLabel.frame = CGRectMake(8, 33, 120, 16);
    self.detailLabel.frame = CGRectMake(WK_SCREEN_WIDTH - 8 - 150, 0, 150, 60);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WKVCLifeCircleRecordModel *)model
{
    _model = model;
    self.titleLabel.text = model.className;
    self.subTitleLabel.text = model.address;
    self.detailLabel.text = [[model.methodName componentsSeparatedByString:@"_"].lastObject stringByReplacingOccurrencesOfString:@"]" withString:@""];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _subTitleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}
@end
