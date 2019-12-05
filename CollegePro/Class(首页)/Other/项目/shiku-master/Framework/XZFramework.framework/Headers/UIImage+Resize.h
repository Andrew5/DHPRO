//
//  UIImage+Resize.h
//  btc
//
//  Created by txj on 15/1/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage(ResizeCategory)
-(UIImage*)resizedImageToSize:(CGSize)dstSize;
-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
@end