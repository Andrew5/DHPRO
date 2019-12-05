//
//  PopMenuViewController.h
//  shiku
//
//  Created by txj on 15/5/21.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopMenuViewControllerDelegate <NSObject>

-(void)hideFinished;

@end
/**
 *  商品属性页弹出
 */
@interface PopMenuViewController : UIViewController
@property (nonatomic, strong) id<PopMenuViewControllerDelegate> delegate;
- (id)initWithCollectionView:(UICollectionView *) anCollectionView;
/**
 *  显示页面
 *
 *  @param view 需要显示的父页面
 */
- (void) showInView:(UIView*)view;
/**
 *  关闭弹出页面
 */
- (void) hideInView;
@end
