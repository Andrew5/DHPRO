//
//  JPShopCarCell.h
//  回家吧
//
//  Created by 王洋 on 16/3/28.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPCarModel.h"

@class JPShopCarCell;
@protocol JPShopCarDelegate <NSObject>
@optional
/**
 * 点击了+号按钮
 */
- (void)productCell:(JPShopCarCell *)cell didClickedPlusBtn:(UIButton *)plusBtn;

/**
 *  点击了-号按钮
 */
- (void)productCell:(JPShopCarCell *)cell didClickedMinusBtn:(UIButton *)minusBtn;
@end

@interface JPShopCarCell : UITableViewCell

@property (nonatomic, copy) JPCarModel *model;


@property (nonatomic, weak) id<JPShopCarDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn; // 选中按钮
@property (weak, nonatomic) IBOutlet UIImageView *headImage; // 头像
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel; // 价格
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; // 名称
@property (weak, nonatomic) IBOutlet UILabel *numLabel; // 数量

@end
