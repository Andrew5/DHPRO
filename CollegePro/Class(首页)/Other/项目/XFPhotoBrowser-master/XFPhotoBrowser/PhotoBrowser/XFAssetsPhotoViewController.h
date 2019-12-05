//
//  XFAssetsPhotoViewController.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;

@interface XFAssetsPhotoViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
