//
//  WKVCDeallocCell.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKVCDeallocCell.h"
#import "WKVCDeallocManager.h"
#import "WKHeader.h"
@interface WKVCDeallocCell ()
@property (strong, nonatomic)  UIImageView *IV;
@property (strong, nonatomic)  UILabel *classNameLabel;
@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic)  UIView *dotView;

@end

@implementation WKVCDeallocCell

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
    [self addSubview:self.IV];
    [self addSubview:self.addressLabel];
    [self addSubview:self.classNameLabel];
    [self addSubview:self.dotView];
    self.IV.frame = CGRectMake(20, 5, 75, 100);
    self.classNameLabel.frame = CGRectMake(110, 25, 120, 18);
    self.addressLabel.frame = CGRectMake(110, 68, 120, 18);
    self.dotView.frame = CGRectMake(WK_SCREEN_WIDTH - 20 - 15, 110 / 2.0 - 7.5, 15, 15);
}


- (void)setModel:(WKDeallocModel *)model
{
    _model = model;
    self.IV.image = model.img;
    self.classNameLabel.text = model.className;
    [self.classNameLabel sizeToFit];
    self.addressLabel.text = model.address;
    self.dotView.hidden = !model.isNeedRelease;//显示既有问题
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)imgClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithImg:)]) {
        [self.delegate clickWithImg:self.model.img];
    }
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:15];
    }
    return _addressLabel;
}

- (UILabel *)classNameLabel
{
    if (!_classNameLabel) {
        _classNameLabel = [UILabel new];
        _classNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _classNameLabel;
}

- (UIView *)dotView
{
    if (!_dotView) {
        _dotView = [UIView new];
        self.dotView.layer.cornerRadius = 7.5;
        self.dotView.backgroundColor = [UIColor redColor];
    }
    return _dotView;
}

- (UIImageView *)IV
{
    if (!_IV) {
        _IV = [[UIImageView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
        [self.IV addGestureRecognizer:tap];
        self.IV.userInteractionEnabled = YES;
    }
    return _IV;
}

@end
