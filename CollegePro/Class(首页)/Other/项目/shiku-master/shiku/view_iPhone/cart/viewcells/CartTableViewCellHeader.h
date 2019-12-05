//
//  CartTableViewCellHeader.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/QCheckBox.h>

@class CartTableViewCellHeader;
@protocol CartTableViewCellHeaderDelegate <NSObject>
- (void)cartTableViewCellHeader:(CartTableViewCellHeader *)cell
                didSelect:(BOOL)selected;
@end
@interface CartTableViewCellHeader : TUITableViewHeaderFooterView<QCheckBoxDelegate>
@property (strong, nonatomic) QCheckBox *checkbox;
@property (nonatomic, strong) id<CartTableViewCellHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) SHOP_ITEM *shop_item;
@end
