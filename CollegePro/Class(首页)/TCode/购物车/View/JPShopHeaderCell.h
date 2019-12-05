//
//  JPShopHeaderCell.h
//  回家吧
//
//  Created by 王洋 on 16/3/28.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPCarModel.h"

@interface JPShopHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, copy) JPCarModel *model;

@end
