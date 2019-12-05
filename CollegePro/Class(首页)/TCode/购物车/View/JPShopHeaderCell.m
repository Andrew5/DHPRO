//
//  JPShopHeaderCell.m
//  回家吧
//
//  Created by 王洋 on 16/3/28.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import "JPShopHeaderCell.h"

@implementation JPShopHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JPCarModel *)model
{
    _model = model;
    self.selectBtn.selected = _model.allSelect;
}

@end
