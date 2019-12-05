//
//  PagePhotosView.h
//
//  Created by txj on 15/1/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosDataSource.h"

@interface PagePhotosView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	
	//id<PagePhotosDataSource> dataSource;
	NSMutableArray *imageViews;
	
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic, assign) id<PagePhotosDataSource> dataSource;
@property (nonatomic, retain) NSMutableArray *imageViews;

- (IBAction)changePage:(id)sender;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource;


//使用方法
/////////////////////广告图片/////////////////////
//AdScrollView * adView = [[AdScrollView alloc] initWithFrame:self.frame];
//adView.adViewCurrentPageIndicatorTintColor=[[TConfig shared] APP_MAIN_COLOR];
//adView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//adView.delegate=self;
//NSMutableArray *imageViewsArray =[[NSMutableArray alloc] initWithCapacity:self.AdItems.count];
//for (int i=0; i<self.AdItems.count; i++) {
//    UIImageView *v=[[UIImageView alloc] init];
//    AdItem *item=[self.AdItems objectAtIndex:i];
//    [v sd_setImageWithURL:[NSURL URLWithString:item.url]  placeholderImage:img_placehold];
//    [imageViewsArray addObject:v];
//}
//adView.imageViewsArray=imageViewsArray;
//adView.PageControlShowStyle = UIPageControlShowStyleCenter;
//adView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//
//[adView setAdTitleArray:nil withShowStyle:AdTitleShowStyleNone];
//
//adView.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
//[self addSubview:adView];
@end
