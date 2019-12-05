//
//  CartTableViewCellFooter.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface OrderDetailTableViewCellFooter : TUITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@property (weak, nonatomic) IBOutlet UILabel *totalFreight;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@property (strong, nonatomic) SHOP_ITEM *shop_item;
@end
