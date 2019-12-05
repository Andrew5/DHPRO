//
//  PagePhotosDataSource.h
//  PagePhotosDemo
//
//  Created by txj on 15/1/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PagePhotosDataSource

// 有多少页
//
- (int)numberOfPages;

// 每页的图片
//
- (UIImage *)imageAtIndex:(int)index;
- (UIImageView *)imageViewAtIndex:(int)index;

-(NSString *)imageUrlAtIndex:(int)index;

@end
