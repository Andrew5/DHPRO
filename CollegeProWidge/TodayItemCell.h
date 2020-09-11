//
//  TodayItemCell.h
//  CollegeProExtension
//
//  Created by jabraknight on 2019/6/15.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodayItemCell : UITableViewCell
@property (strong, nonatomic)UIImageView *imageViewMy;
@property (strong, nonatomic)UILabel  *labelTitleName;
@property (strong, nonatomic)UILabel  *detailLabelTitleName;
@property (nonatomic, strong)TodayItemModel *model;
@end

NS_ASSUME_NONNULL_END
