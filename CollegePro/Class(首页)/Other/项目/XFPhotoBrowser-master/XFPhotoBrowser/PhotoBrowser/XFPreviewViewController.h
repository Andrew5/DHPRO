//
//  XFPreviewViewController.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/8/12.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteImageBlock)(NSInteger index);

@interface XFPreviewViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *assetsArray;

@property (assign, nonatomic) NSInteger showIndex;

@property (copy, nonatomic) DeleteImageBlock deleteImageBlock;

@end
