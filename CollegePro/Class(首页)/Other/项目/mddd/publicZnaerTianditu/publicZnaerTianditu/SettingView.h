//
//  SettingView.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/23.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "OffLineMapViewController.h"
@interface SettingView : BaseView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)UIButton    *exitBtn;

@end
