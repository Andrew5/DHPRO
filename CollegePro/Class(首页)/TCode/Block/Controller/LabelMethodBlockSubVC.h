//
//  LabelMethodBlockSubVC.h
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^ReturnTextBlock)(NSString *showText);

@interface LabelMethodBlockSubVC : BaseViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

+ (void)getMyBestMethod:(void (^)(NSDictionary *dict))then;
- (void)getMyBestMethod:(void (^)(NSString *))then;
- (void)testNormalBlock;
- (void)showIndex: (NSInteger) index;
@end
