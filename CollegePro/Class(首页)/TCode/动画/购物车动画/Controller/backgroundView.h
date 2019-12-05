//
//  backgroundView.h
//  CollegePro
//
//  Created by jabraknight on 2019/5/23.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnTextBlock)(void);

@interface backgroundView : UIView

@property (nonatomic, copy) ReturnTextBlock lastTapBlock;

+ (instancetype)sureGuideView;
@end

NS_ASSUME_NONNULL_END
