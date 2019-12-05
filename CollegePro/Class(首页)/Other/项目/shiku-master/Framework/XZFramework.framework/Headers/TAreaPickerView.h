//
//  TAreaPicker.h
//  btc
//
//  Created by txj on 15/2/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLocation.h"
#import "TConfig.h"

typedef enum {
    TAreaPickerWithStateAndCity,
    TAreaPickerWithStateAndCityAndDistrict
} TAreaPickerStyle;

@class TAreaPickerView;

@protocol TAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(TAreaPickerView *)picker;
- (void)pickerDidTapedOKBtn:(TAreaPickerView *)picker;

@end

@interface TAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <TAreaPickerDelegate> delegate;
@property (strong, nonatomic) UIPickerView *locatePicker;
@property (strong, nonatomic) TLocation *locate;
@property (nonatomic) TAreaPickerStyle pickerStyle;

- (id)initWithStyle:(TAreaPickerStyle)pickerStyle frame:(CGRect)frame delegate:(id<TAreaPickerDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
