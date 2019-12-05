//
//  XFCameraViewController.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/11.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFAssetsModel;
typedef void(^TakePhotosBlock)(XFAssetsModel *model);

@interface XFCameraViewController : UIViewController <UIGestureRecognizerDelegate>
/**
 *  相机放大的最大比例,默认为4.0
 */
@property (assign, nonatomic) CGFloat maxEffectiveScale;
/**
 *  相机初始比例,默认为1.0
 */
@property (assign, nonatomic) CGFloat beginEffectiveScale;

@property (copy, nonatomic) TakePhotosBlock takePhotosBlock;

@end
