//
//  XFBrowerViewController.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/20.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;

typedef void(^CallBack)(NSArray *selectedArray);

@interface XFBrowerViewController : UINavigationController
/**
 *  选择图片的最大数,如果不设置就不作限制
 */
@property (assign, nonatomic) NSInteger maxPhotosNumber;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (strong, nonatomic) NSArray *selectedAssets;

@property (copy, nonatomic) CallBack callback;

+ (instancetype)shareBrowerManager;
@end
