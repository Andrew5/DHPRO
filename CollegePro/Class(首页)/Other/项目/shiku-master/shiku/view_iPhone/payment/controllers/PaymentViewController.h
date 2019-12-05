//
//  PaymentViewController.h
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cart.h"
#import "PaymentBackend.h"
#import "PaymentTableViewCell.h"
#import "OrderSummaryTableViewCell.h"
#import "WXApi.h"

/**
 *  支付
 */
@interface PaymentViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,WXApiDelegate,UIAlertViewDelegate>
{
    NSMutableArray *paymentIconArray;
    NSMutableArray *paymentTextArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Cart *cart;
@property (strong, nonatomic) ORDER *order;
/**
 *  初始化订单
 *
 */
-(instancetype)initWithOrder:(ORDER *)anOrder;

@property (strong, nonatomic) PaymentBackend *backend;
@end
