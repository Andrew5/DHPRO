//
//  GLPageScrollView.h
//  GLPageUIScrollView
//
//  Created by 高磊 on 2017/3/3.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 点击block

 @param atIndex 点击的index
 */
typedef void(^GLPageScrollViewDidSelectIndexBlock)(NSInteger atIndex);


/**
 滚动block

 @param toIndex 滚动到的位置
 */
typedef void(^GLPageScrollviewDidScrollToIndexBlock)(NSInteger toIndex);

@interface GLPageScrollView : UIView

//装图片的数组 可以是图片也可以是地址
@property (nonatomic,strong) NSMutableArray *images;
//轮播图定时
@property (nonatomic,assign) NSTimeInterval timeinterval;

@property (nonatomic,copy) GLPageScrollViewDidSelectIndexBlock didSelectIndexBlock;

@property (nonatomic,copy) GLPageScrollviewDidScrollToIndexBlock didScrollToIndexBlock;

/**
 *  启动定时器
 */
- (void)startTimer;

/**
 *  暂停定时器
 */
- (void)pauseTimer;

@end
