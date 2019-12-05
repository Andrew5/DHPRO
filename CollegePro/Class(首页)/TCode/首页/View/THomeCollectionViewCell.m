//
//  THomeCollectionViewCell.m
//  Test
//
//  Created by Rillakkuma on 2017/7/8.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "THomeCollectionViewCell.h"
@interface THomeCollectionViewCell ()
{
    UILabel *_labelName;
    UIImageView *_imageCover;
}
@end
@implementation THomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_labelName = [[UILabel alloc]init];
		_labelName.textAlignment = NSTextAlignmentCenter;
		_labelName.textColor = [UIColor blackColor];
		_labelName.font = DH_FontSize(12);
        _labelName.numberOfLines = 0;
//        [_labelName sizeToFit];
		_imageCover = [[UIImageView alloc]init];
		_imageCover.layer.cornerRadius = 15;
//		[_imageCover setContentScaleFactor:[[UIScreen mainScreen] scale]];
//		_imageCover.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//		_imageCover.contentMode = UIViewContentModeScaleAspectFill;
//		_imageCover.clipsToBounds = YES;
        [self.contentView addSubview:_labelName];
		[self.contentView addSubview:_imageCover];
        [_labelName setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:UILayoutConstraintAxisVertical];

        [_imageCover mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(5);
//            make.right.offset(-5);
//            make.top.offset(10);
//            make.size.mas_equalTo(CGSizeMake(100, 100));
//            make.top.equalTo(self.contentView).with.offset(10);
            make.width.and.height.mas_equalTo(40);
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).and.offset(-10);
        }];
        
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_imageCover.mas_bottom).and.offset(5);
            make.top.equalTo(_imageCover.mas_bottom).and.offset(5);
            make.centerX.equalTo(self.contentView);
            make.left.offset(5);
            make.right.offset(-5);
//            make.height.offset(50);
        }];

	}
	return self;
}
-(void)setTitle:(NSString *)title{
    _title = title;
    _labelName.text = _title;
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    _imageCover.image = [UIImage imageNamed:imageName];
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGFloat margin = 10;
//
//    _labelName.sd_layout
//    .leftSpaceToView(self.contentView, 10)
//    .rightSpaceToView(self.contentView, 10)
//    .topSpaceToView(self.contentView, 10)
//    .autoHeightRatio(0);
//
//
//    _imageCover.sd_layout
//    .topSpaceToView(_labelName, 10)
//    .widthRatioToView(_labelName, 1)
//    .heightIs(30)
//    .leftEqualToView(_labelName);
//
//    [self setupAutoHeightWithBottomView:_imageCover bottomMargin:margin];
//
//}
@end
