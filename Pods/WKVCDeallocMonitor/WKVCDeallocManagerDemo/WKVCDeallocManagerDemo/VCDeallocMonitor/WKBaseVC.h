//
//  WKBaseVCViewController.h
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/4/18.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKNavView.h"
@interface WKBaseVC : UIViewController<WKNavViewDelegate>

@property (nonatomic, strong) WKNavView * nav;

@end
