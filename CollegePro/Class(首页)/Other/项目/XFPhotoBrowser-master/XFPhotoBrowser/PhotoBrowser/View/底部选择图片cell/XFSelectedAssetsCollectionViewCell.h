//
//  XFSelectedAssetsCollectionViewCell.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFAssetsModel;

typedef void(^DeleteAssetBlock)(XFAssetsModel *asset);

@interface XFSelectedAssetsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) XFAssetsModel *model;
@property (copy, nonatomic) DeleteAssetBlock deleteAssetBlock;
@end
