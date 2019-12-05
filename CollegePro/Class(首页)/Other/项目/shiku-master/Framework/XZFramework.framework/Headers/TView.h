//
//  TView.h
//  btc
//
//  Created by txj on 15/1/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface TView : UIView

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (assign, nonatomic) IBInspectable UIColor *borderColor;
@property (assign, nonatomic) IBInspectable CGFloat topBorderWidth;
@property (assign, nonatomic) IBInspectable UIColor *topBorderColor;
@property (assign, nonatomic) IBInspectable CGFloat rightBorderWidth;
@property (assign, nonatomic) IBInspectable UIColor *rightBorderColor;
@property (assign, nonatomic) IBInspectable CGFloat bottomBorderWidth;
@property (assign, nonatomic) IBInspectable UIColor *bottomBorderColor;
@property (assign, nonatomic) IBInspectable CGFloat leftBorderWidth;
@property (assign, nonatomic) IBInspectable UIColor *leftBorderColor;
@end

