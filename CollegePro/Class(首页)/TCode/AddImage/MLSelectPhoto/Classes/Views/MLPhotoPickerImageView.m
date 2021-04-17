//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerImageView.m
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "MLPhotoPickerImageView.h"
#import "MLSelectPhotoCommon.h"

@interface MLPhotoPickerImageView ()

@property (nonatomic , weak) UIView *maskView;
@property (nonatomic , weak) UIButton *tickImageView;
@property (nonatomic , weak) UIImageView *videoView;

@end

@implementation MLPhotoPickerImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.hidden = YES;
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    return _maskView;
}

- (UIImageView *)videoView{
    if (!_videoView) {
        UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 40, 30, 30)];
        videoView.image = [UIImage imageNamed:MLSelectPhotoSrcName(@"video")];
        videoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:videoView];
        self.videoView = videoView;
    }
    return _videoView;
}

- (UIButton *)tickImageView{
    if (!_tickImageView) {
        UIButton *tickImageView = [[UIButton alloc] init];
        tickImageView.frame = CGRectMake(self.bounds.size.width - 30, 0, 30, 30);
        [tickImageView addTarget:self action:@selector(clickTick) forControlEvents:UIControlEventTouchUpInside];
        [tickImageView setImage:[UIImage imageNamed:MLSelectPhotoSrcName(@"icon_image_no")] forState:UIControlStateNormal];
        [self addSubview:tickImageView];
        self.tickImageView = tickImageView;
    }
    return _tickImageView;
}

- (void)setIsVideoType:(BOOL)isVideoType{
    _isVideoType = isVideoType;
    
    self.videoView.hidden = !(isVideoType);
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag{
    _maskViewFlag = maskViewFlag;
    
    self.animationRightTick = maskViewFlag;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    self.tickImageView.tag = index;
}

- (void)clickTick{
    if ([self.delegate respondsToSelector:@selector(photoPickerClickTickButton:)]) {
        [self.delegate photoPickerClickTickButton:self.tickImageView];
    }
}

- (void)setAnimationRightTick:(BOOL)animationRightTick{
    _animationRightTick = animationRightTick;
    
    if (animationRightTick) {
        [self.tickImageView setImage:[UIImage imageNamed:MLSelectPhotoSrcName(@"icon_image_yes")] forState:UIControlStateNormal];
    }else{
        [self.tickImageView setImage:[UIImage imageNamed:MLSelectPhotoSrcName(@"icon_image_no")] forState:UIControlStateNormal];
    }
    
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    
    if (self.isVideoType) {
        [self.videoView.layer removeAllAnimations];
        [self.videoView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }else{
        [self.tickImageView.layer removeAllAnimations];
        [self.tickImageView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }
    
}
@end
