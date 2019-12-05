//
//  LHStickerView.h
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/15.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHStickerView;
@protocol LHStickerViewDelegate <NSObject>

- (void)deleteStickerView:(LHStickerView *)stickerView;
- (void)stickerViewOnRect:(CGRect)rect;
@end

@interface LHStickerView : UIView

@property (nonatomic, weak) id <LHStickerViewDelegate> delegate;

+ (void)setActiveStickerView:(LHStickerView*)view;

- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
- (void)setScale:(CGFloat)scaleX andScaleY:(CGFloat)scaleY;
@end
