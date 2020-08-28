//
//  DHDetailViewController.h
//  CollegePro
//
//  Created by jabraknight on 2019/7/15.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DHDetailDelegate <NSObject>

- (void)tableViewSelectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

@end
@interface DHDetailViewController : BaseViewController
@property (nonatomic, weak) id<DHDetailDelegate> delegate;

- (void)tableViewScrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
