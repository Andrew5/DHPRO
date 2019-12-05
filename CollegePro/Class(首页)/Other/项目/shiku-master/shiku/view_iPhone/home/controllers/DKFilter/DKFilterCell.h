//
//  DKRadioSelectView.h
//  Partner
//
//  Created by Drinking on 14-12-19.
//  Copyright (c) 2014年 zhinanmao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DKFilterModel;

@interface DKFilterCell : UIView

@property (nonatomic,assign) NSInteger buttonWidth;
@property (nonatomic,assign) NSInteger buttonHeight;
@property (nonatomic,assign) NSInteger paddingHorizontal;
@property (nonatomic,assign) NSInteger paddingVertical;
@property (nonatomic,assign) NSInteger paddingBottom;
@property (nonatomic,assign) CGFloat maxViewWidth;
@property (nonatomic,strong) UIColor *buttonNormalColor;
@property (nonatomic,strong) UIColor *buttonHighlightColor;


- (instancetype)init:(DKFilterModel *) model Width:(CGFloat) width;
- (CGFloat)getEstimatedHeight;
- (void)setSelectedChoice:(NSString *)choice;
- (NSArray *)getSelectedValues;
@end


