//
//  ImageFilterProcessViewController.h
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageFitlerProcessDelegate;
@interface ImageFilterProcessViewController : UIViewController<UIGestureRecognizerDelegate>
{
   __strong UIImageView *rootImageView;
    UIScrollView *scrollerView;
    UIImage *currentImage;
//    id <ImageFitlerProcessDelegate> delegate;
    UIView *line;
}
@property(nonatomic,assign) id<ImageFitlerProcessDelegate> delegate;
@property(nonatomic,retain)UIImage *currentImage;
@end

@protocol ImageFitlerProcessDelegate <NSObject>

- (void)imageFitlerProcessDone:(UIImage *)image;
@end
