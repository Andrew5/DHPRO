//
//  UIScrollView+PullBig.h
//  CollegePro
//
//  Created by Rillakkuma on 2018/11/29.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIScrollView (PullBig)
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView *headerView;
-(void)setBigView:(UIView *)bigView withHeaderView:(UIView *)headerView;
@end
