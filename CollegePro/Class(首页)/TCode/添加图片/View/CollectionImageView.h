//
//  CollectionImageView.h
//  CollectionView轮播图
//
//  Created by xiaoshi on 16/2/17.
//  Copyright © 2016年 kamy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectImageBlock)(NSInteger index);

@interface CollectionImageView : UIView
/**
 *  封装collectionView实现轮播图
 *
 *  @param frame      传入轮播图的frame
 *  @param imageArray 图集数组表示
 *  @param block      点击图片的方法用block公开出去
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray selectImageBlock:(selectImageBlock) block;
@end
