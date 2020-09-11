//
//  WKNavView.h
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/4/18.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHeader.h"

@protocol WKNavViewDelegate <NSObject>

@optional
- (void)backItemClick;
- (void)detailItemClick;

@end
@interface WKNavView : UIView

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * backTitle;
@property (nonatomic, strong) NSString * detailTitle;
@property (nonatomic, weak  ) id<WKNavViewDelegate> delegate;

@end
