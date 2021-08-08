//
//  LabelMethodBlockSubVC.h
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^ReturnTextBlock)(NSString * _Nonnull showText);
typedef BOOL(^ReturnCustomValicationBlock)(NSString *originContent, NSString *customContent);
static NSString * const SD_PLT              = @"iPhone";
extern NSString * const ABC;
@interface LabelMethodBlockSubVC : BaseViewController
@property (nonatomic, copy) ReturnTextBlock _Nullable returnTextBlock;

- (void)returnText:(ReturnTextBlock _Nonnull )block;
- (void)returnContent:(ReturnCustomValicationBlock _Nonnull )block;

+ (void)getMyBestMethod:(void (^_Nullable)(NSDictionary * _Nonnull))then;
- (void)getMyBestMethod:(void (^_Nonnull)(NSString * _Nonnull))then;
- (void)testNormalBlock;
- (void)showIndex: (NSInteger) index;
@end
