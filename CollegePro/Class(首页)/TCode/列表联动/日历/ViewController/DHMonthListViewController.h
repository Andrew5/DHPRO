//
//  DHMonthListViewController.h
//  CollegePro
//
//  Created by jabraknight on 2019/7/4.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DHMonthListViewControllerDelegate <NSObject>
//设置选中行的代理
- (void)monthListTableView:(UITableView *)tableView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface DHMonthListViewController : BaseViewController
@property (nonatomic, strong) NSArray *months;

@property (nonatomic, weak) id <DHMonthListViewControllerDelegate> delegate;
//左侧列表选择的行
- (void)tableViewSelectCellAtIndexpath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
