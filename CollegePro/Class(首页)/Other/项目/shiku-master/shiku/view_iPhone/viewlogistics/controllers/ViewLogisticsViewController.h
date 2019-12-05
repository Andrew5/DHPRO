//
//  OrderDetailViewController.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListTableViewCell.h"
#import "OrderDetailTableViewCellHeader.h"
#import "OrderDetailTableViewCellFooter.h"
#import "OrderButtomBarTableViewCellFooter.h"
#import "ViewLogisticsTableViewCell.h"
#import "OrderDetailSection2TableViewCell.h"
#import "OrderDetailSection4TableViewCell.h"
#import "AddressTableViewCell.h"
#import "OrderListTableViewCellFooter.h"
#import "OrderBackend.h"
#import "ViewLogisticsWebviewTableViewCell.h"
/**
 *  生产日志
 */

@interface ViewLogisticsViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,OrderListTableViewCellFooterDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) OrderBackend *backend;
@property (strong, nonatomic) ORDER* order;//订单对象

/**
 *  根据订单进行初始化
 *
 */
-(instancetype)initWithOrder:(ORDER *)anOrder;
@end
