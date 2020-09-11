//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BaseViewController.h"

@interface SlideMenuViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *cellIdentifier;
@property(nonatomic,strong) UITableView *tableViewMy;

@end
