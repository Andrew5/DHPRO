//
//  HYBSectionModel.h
//  SectionAnimationDemo
//
//  Created by huangyibiao on 16/6/8.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBSectionModel : NSObject

@property (nonatomic, copy) NSString *sectionTitle;
// 是否是展开的
@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, strong) NSMutableArray *cellModels;

@end

@interface HYBCellModel : NSObject

@property (nonatomic, copy) NSString *title;

@end