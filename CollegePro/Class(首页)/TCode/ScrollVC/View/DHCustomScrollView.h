//
//  DHCustomScrollView.h
//  CollegePro
//
//  Created by jabraknight on 2020/12/22.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHCustomScrollView : UIView
///装图片的数组 可以是图片也可以是地址
@property (nonatomic,strong) NSMutableArray *images;
///轮播图定时
@property (nonatomic,assign) NSTimeInterval timeinterval;

- (void)startTimer;
- (void)pauseTimer;

- (void)pageScrollViewDidSelectIndexBlock:(void(^)(NSInteger toIndex))inforBlock;
- (void)pageScrollViewDidScrollToIndexBlock:(void(^)(NSInteger toIndex))inforBlock;


@end

NS_ASSUME_NONNULL_END
