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
#import "OrderDetailSection0TableViewCell.h"
#import "OrderDetailSection2TableViewCell.h"
#import "OrderDetailSection4TableViewCell.h"
#import "AddressTableViewCell.h"
#import "OrderListTableViewCellFooter.h"
#import "ViewLogisticsViewController.h"
#import "OrderBackend.h"
#import "PaymentViewController.h"
/**
 *  订单详情
 */
@interface OrderDetailViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,OrderListTableViewCellFooterDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) OrderBackend *backend;
@property (strong, nonatomic) ORDER* order;//ADDRESS
/**
 *  初始化
 *
 */
-(instancetype)initWithOrder:(ORDER *)anOrder;
@end
