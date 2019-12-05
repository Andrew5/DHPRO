//
//  CartTableViewCell.h
//  btc
//
//  Created by txj on 15/3/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBindableTableViewCell.h"
#import <XZFramework/QCheckBox.h>
#import <XZFramework/TextStepperField.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface OrderListTableViewCell : TUITableViewCell<QCheckBoxDelegate>

- (void)bind:(NSNumber *)Number;

@property (strong, nonatomic) CART_GOODS *cartItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageWith;

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
