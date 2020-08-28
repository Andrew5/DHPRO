//
//  CricleScrollViewController.h
//  CollegePro
//
//  Created by jabraknight on 2019/9/2.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CricleScrollViewDelegate <NSObject>

- (void) cricleScrollViewDidScroll:(UIScrollView *)scrollView;
- (void) cricleScrollViewDidScrollToIndex:(NSInteger)index;

@end
@interface CricleScrollViewController : BaseViewController
@property (nonatomic,readonly) UIScrollView *cricleScrollerview;
@property (nonatomic,strong) NSArray *imageViewsDatasrc;
@property (nonatomic,strong) id<CricleScrollViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame  andImagesArray:(NSArray *)imagesArray;
@end

NS_ASSUME_NONNULL_END
