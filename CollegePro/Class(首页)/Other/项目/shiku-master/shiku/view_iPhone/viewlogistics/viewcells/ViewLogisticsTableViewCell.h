//
//  OrderDetailSection0TableViewCell.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  cell模板，各属性请对照.xib文件
 */
@interface ViewLogisticsTableViewCell : TUITableViewCell
@property (strong, nonatomic) ORDER *order;

@property (weak, nonatomic) IBOutlet UILabel *freightStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *freight;

@end
