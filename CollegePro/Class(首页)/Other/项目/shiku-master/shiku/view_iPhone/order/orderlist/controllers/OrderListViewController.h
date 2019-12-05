//
//  OrderViewController.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderBackend.h"
#import <XZFramework/ThreeStageSegmentView.h>

#import "OrderListTableViewCell.h"
#import "OrderListTableViewCellHeader.h"
#import "OrderListTableViewCellFooter.h"
#import "ViewLogisticsViewController.h"
#import "PaymentViewController.h"
#import "OrderDetailViewController.h"
/**
 *  订单列表
 */
@interface OrderListViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,ThreeStageSegmentViewDelegate,OrderListTableViewCellFooterDelegate,OrderDelegate>

@property (weak, nonatomic) IBOutlet UIView *threeSegmentBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* datalist;
@property (strong, nonatomic) OrderBackend *backend;
@property (strong, nonatomic) FILTER *filter;
@property (nonatomic, weak) USER *user;
/**
 *  根据订单状态初始化订单列表
 *
 */
-(instancetype)initWithOrderStatus:(NSInteger)status;
@end
