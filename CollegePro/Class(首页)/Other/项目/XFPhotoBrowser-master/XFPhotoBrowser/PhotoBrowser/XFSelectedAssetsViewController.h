//
//  XFSelectedAssetsView.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFAssetsModel;

typedef void(^DeleteAssetsBlock)(XFAssetsModel *model);

typedef void(^ConfirmBlock)();

@interface XFSelectedAssetsViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (assign, nonatomic) NSInteger maxPhotosNumber;

@property (copy, nonatomic) DeleteAssetsBlock deleteAssetsBlock;

@property (copy, nonatomic) ConfirmBlock confirmBlock;

- (void)addModelWithData:(NSArray<XFAssetsModel *> *)data;

- (void)deleteModelWithData:(NSArray<XFAssetsModel *> *)data;

- (void)removeData;

+ (instancetype)makeView;

@end
