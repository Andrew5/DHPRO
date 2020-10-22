//
//  DHSegmentCommenMannager.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSegmentCommenMannager : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollBig;
@property (nonatomic, strong) UIView *typeView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *tmpBtn;
@property (nonatomic, strong) NSArray *infoarray;
@property (nonatomic, strong) UIViewController *superVC;

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentVC;
@end

NS_ASSUME_NONNULL_END
