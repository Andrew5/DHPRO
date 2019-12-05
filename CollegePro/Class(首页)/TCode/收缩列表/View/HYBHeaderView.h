//
//  HYBHeaderView.h
//  SectionAnimationDemo
//
//  Created by huangyibiao on 16/6/8.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYBSectionModel;

typedef void(^HYBHeaderViewExpandCallback)(BOOL isExpanded);

@interface HYBHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) HYBSectionModel *model;
@property (nonatomic, copy) HYBHeaderViewExpandCallback expandCallback;

@end
