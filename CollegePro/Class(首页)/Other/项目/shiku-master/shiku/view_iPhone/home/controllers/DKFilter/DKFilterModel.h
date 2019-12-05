//
//  DKFilterModel.h
//  Partner
//
//  Created by Drinking on 14-12-19.
//  Copyright (c) 2014年 zhinanmao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DKFilterType){
    DK_SELECTION_SINGLE,DK_SELECTION_MULTIPLE,DK_SELECTION_PICK
};

typedef NS_ENUM(NSInteger, DKFilterViewStyle){
    DKFilterViewDefault,DKFilterViewStyle1
};

@interface DKFilterModel : NSObject

@property (nonatomic,assign) DKFilterType type;
@property (nonatomic,strong,readonly) NSArray *elements;
@property (nonatomic,strong) NSArray *choices;
@property (nonatomic,strong) UIView *cachedView;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSDictionary *originData;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) DKFilterViewStyle style;
@property (nonatomic,copy) NSString *clickedButtonText;

- (instancetype)initElement:(NSArray*)array ofType:(DKFilterType)type;
- (UIView *)getCustomeViewofWidth:(CGFloat)width;
- (NSArray *)getFilterResult;
@end
