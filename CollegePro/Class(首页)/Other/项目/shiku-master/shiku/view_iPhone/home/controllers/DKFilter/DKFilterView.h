//
//  DKFilterView.h
//  Partner
//
//  Created by Drinking on 14-12-20.
//  Copyright (c) 2014年 zhinanmao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKFilterSectionHeaderView.h"
#import "DKMacros.h"
#import "DKFilterModel.h"
@protocol DKFilterViewDelegate <NSObject>

@optional
- (NSInteger)getCustomSectionHeaderHeight;
- (DKFilterSectionHeaderView *)getCustomSectionHeader;
- (void)didClickAtModel:(DKFilterModel *)data;
@end

@interface DKFilterView : UIView
@property (nonatomic,strong) NSArray *filterModels;
@property (nonatomic,weak) id<DKFilterViewDelegate> delegate;
@end
