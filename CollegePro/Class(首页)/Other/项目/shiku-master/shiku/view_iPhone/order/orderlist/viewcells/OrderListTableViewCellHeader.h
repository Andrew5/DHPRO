//
//  CartTableViewCellHeader.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/QCheckBox.h>


/**
 *  cell模板，各属性请对照.xib文件
 */
@interface OrderListTableViewCellHeader : TUITableViewHeaderFooterView<QCheckBoxDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) ORDER *order;
@end
