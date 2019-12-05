//
//  JHDownButton.h
//  GBCheckUpLibrary
//
//  Created by jabraknight on 2019/5/24.
//  Copyright © 2019 jinher. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDownButton : UIControl
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *title;
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
