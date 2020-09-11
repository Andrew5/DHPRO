//
//  WKWebViewController.h
//  CollegePro
//
//  Created by jabraknight on 2020/4/6.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewController : BaseViewController
@property (nonatomic, strong) NSString *navTitle;

- (instancetype)initWithUrl:(NSString *)url navTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
