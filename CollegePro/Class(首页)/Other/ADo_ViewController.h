//
//  ADo_ViewController.h
//  Test
//
//  Created by Rillakkuma on 2016/10/31.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Extension.h"

#import "homeViewController.h"

#define screenW self.view.frame.size.width

#define screenH self.view.frame.size.height

#define pageCount 5

#define picH 2330 / 2

#define padding 200

#define topPicH 70

#define topPicW 112

#define btnH 100

#define btnW 140

@interface ADo_ViewController : UIViewController
/**
 
 * 底部滚动图片
 
 */

@property (nonatomic,strong)UIScrollView *guideView;

/**
 
 * 球形图片
 
 */

@property (nonatomic,strong)UIImageView *picView;

/**
 
 * 牌型滚动
 
 */

@property (nonatomic,strong)UIImageView *paiView;

/**
 
 * 指示
 
 */

@property (nonatomic,strong)UIPageControl *pageControl;

/**
 
 * 顶部图片滚动
 
 */

@property (nonatomic,strong)UIScrollView *topView;

@end
