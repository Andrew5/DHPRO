//
//  OrderDetailSection3TableViewCell.h
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface OrderDetailSection4TableViewCell : TUITableViewCell
@property (strong, nonatomic) ORDER *order;

@property (weak, nonatomic) IBOutlet UILabel *orderidLabel;
@property (weak, nonatomic) IBOutlet UILabel *paysnLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkTimeLabel;

@end
