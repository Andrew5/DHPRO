//
//  SearchFriendsResultTableViewViewController.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchFriendsResultTableViewViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSArray     *data;

@property(nonatomic, strong)id<PassValueDelegate> valueDelegate;

@end
