//
//  adViewView.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/22.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol adViewViewDelegate <NSObject>

-(void)sendadButton:(UIButton *)button;

@end
@interface adViewView : UICollectionReusableView<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,assign)id<adViewViewDelegate>delegate;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)NSMutableArray *array;
@end
