//
//  AdScrollView.h
//  广告循环滚动效果
//
//  Created by txj on 15/1/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};
@protocol AdScrollViewDelgate<NSObject>
@optional
-(void)imageCliked:(NSInteger *)index;
@end
@interface AdScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign) id<AdScrollViewDelgate> delegate;
@property (retain,nonatomic,readonly) UIPageControl * pageControl;
//@property (retain,nonatomic,readwrite) NSArray * imageNameArray;
@property (retain,nonatomic,readwrite) NSArray * imageViewsArray;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;
@property (assign,nonatomic,readwrite) UIPageControlShowStyle  PageControlShowStyle;
@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;
@property (assign,nonatomic) UIColor* adViewCurrentPageIndicatorTintColor;

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
@end
 
