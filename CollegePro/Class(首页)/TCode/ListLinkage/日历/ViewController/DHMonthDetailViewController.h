//
//  DHMonthDetailViewController.h
//  CollegePro
//
//  Created by jabraknight on 2019/7/4.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DHMonthDetailViewControllerDelegate <NSObject>

- (void)monthDetailCollectionView:(UICollectionView *)collectionView didScrollToIndexPath:(NSIndexPath *)indexPath;

@end

@interface DHMonthDetailViewController : BaseViewController

@property (nonatomic, strong) NSArray *months;

@property (nonatomic, weak) id <DHMonthDetailViewControllerDelegate> delegate;
//右侧列表
- (void)collectionViewScrollToItemAtIndexpath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
