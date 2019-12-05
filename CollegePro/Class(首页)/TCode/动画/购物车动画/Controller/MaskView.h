//
//  MaskView.h
//  CollegePro
//
//  Created by jabraknight on 2019/5/24.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaskView : UIView<UIGestureRecognizerDelegate>
-(instancetype)initWithFrame:(CGRect)frame;

+(instancetype)makeViewWithMask:(CGRect)frame andView:(UIView*)view;

-(void)block:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
