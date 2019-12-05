//
//  UIView+Extension.h
//  btc
//
//  Created by txj on 15/1/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SeparatorDirectionTop = 0x01,
    SeparatorDirectionRight = 0x02,
    SeparatorDirectionBottom = 0x04,
    SeparatorDirectionLeft = 0x08,
    SeparatorDirectionAll = SeparatorDirectionTop | SeparatorDirectionRight |
    SeparatorDirectionBottom | SeparatorDirectionLeft
} SeparatorDirection;

@interface SeparatorOption : NSObject

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) SeparatorDirection direction;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float indent;
@property (assign, nonatomic) CGFloat marginTop;
@property (assign, nonatomic) CGFloat marginRight;
@property (assign, nonatomic) CGFloat marginBottom;
@property (assign, nonatomic) CGFloat marginLeft;

- (id)initWithColor:(UIColor *)color marginLeftAndRight:(CGFloat)marginWidth
        onDirection:(SeparatorDirection)direction;

+ (id)optionWithColor:(UIColor *)color marginLeftAndRight:(CGFloat)marginWidth
          onDirection:(SeparatorDirection)direction;
+ (id)optionWithDirection:(SeparatorDirection)direction;
+ (id)optionWithColor:(UIColor *)color
          onDirection:(SeparatorDirection)direction;
+ (id)optionWithColor:(UIColor *)color
          onDirection:(SeparatorDirection)direction
                width:(float)width indent:(float)aIndent;
@end

@interface UIView (Extention)
//@property (strong, nonatomic) MBProgressHUD *hud;
- (void)setSeparatorOnDirection:(SeparatorDirection)direction;
- (void)setSeparatorWithOption:(SeparatorOption *)option;
- (void)showHUD:(NSString *)message afterDelay:(NSTimeInterval)delay;
- (void)showWaitingHUD:(NSString *)message whileExcuting:(SEL)selector onTarget:(id)target;
-(void)hideWaitingHUD;
@end