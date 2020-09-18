//
//  DHVideoFileListVCViewController.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHVideoFileListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *videoTBV;
@property(nonatomic,strong) NSMutableArray *alldataArray;
@end

NS_ASSUME_NONNULL_END
