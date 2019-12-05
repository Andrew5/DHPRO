//
//  OrderSummaryTableViewCell.h
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface OrderSummaryTableViewCell : TUITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
/**
 * 运费
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
/**
 * 订单金额
 */
@property (weak, nonatomic) IBOutlet UILabel *orderFreightLabel;
@property (strong, nonatomic) ORDER *order;
/**
 * 运费View
 */
@property (weak, nonatomic) IBOutlet UIView *orderIView;
/**
 * 订单金额View
 */
@property (weak, nonatomic) IBOutlet UIView *orderIIView;

@end
