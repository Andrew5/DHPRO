//
//  JPShopCarCell.m
//  回家吧
//
//  Created by 王洋 on 16/3/28.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import "JPShopCarCell.h"

@implementation JPShopCarCell

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
    self.numLabel.text = [NSString stringWithFormat:@"%d", _model.buyCount];
    self.selectBtn.selected = _model.selected;
    self.nameLabel.text = _model.name;
    self.moneyLabel.text = _model.price;
}

// 加
- (IBAction)plusBtnClick
{
    NSLog(@"+");
    if ([self.delegate respondsToSelector:@selector(productCell:didClickedPlusBtn:)]) {
        [self.delegate productCell:self didClickedPlusBtn:nil];
    }
}

// 减
- (IBAction)minusBtnClick
{
    NSLog(@"-");
    if ([self.delegate respondsToSelector:@selector(productCell:didClickedMinusBtn:)]) {
        [self.delegate productCell:self didClickedMinusBtn:nil];
    }
}

@end
