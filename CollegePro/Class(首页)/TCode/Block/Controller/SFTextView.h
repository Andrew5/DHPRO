//
//  SFTextView.h
//  Demo
//
//  Created by 佘峰 on 2018/4/5.
//  Copyright © 2018年 佘峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTextView : UITextView

- (void)setPlaceHolderAttr:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

- (void)setCharCountAttr:(NSInteger)charCount right:(NSInteger)right bottom:(NSInteger)bottom textColor:(UIColor *)textColor font:(UIFont *)font;

@end
