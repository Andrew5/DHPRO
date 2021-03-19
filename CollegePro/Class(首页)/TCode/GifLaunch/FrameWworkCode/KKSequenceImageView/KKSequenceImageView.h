//
//  KKSequenceImage.h
//  KKShopping
//
//  Created by kevin on 2017/5/18.
//  Copyright © 2017年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKSequenceImageView;

@protocol KKSequenceImageDelegate <NSObject>

@optional

- (void)sequenceImageDidPlayCompeletion:(KKSequenceImageView *)imageView;

@end

@interface KKSequenceImageView : UIImageView

/*
 * 每一张图的间隔,单位是MS
 */
@property (nonatomic, assign) NSUInteger durationMS;
/*
 * 重复播放次数
 */
@property (nonatomic, assign) NSUInteger repeatCount;
/*
 * 图片地址数组,这个地址将被用于imageWithContentsOfFile的方式获取图片
 */
@property (nonatomic, strong) NSArray<NSString *> *imagePathss;
/*
 * 是否正在播放动画中
 */
@property (nonatomic, assign, readonly) BOOL animatingNow;
/*
 * 代理
 */
@property (nonatomic, weak)   id<KKSequenceImageDelegate> delegate;

/*
 * 开始动画
 */
- (void)begin;

@end
