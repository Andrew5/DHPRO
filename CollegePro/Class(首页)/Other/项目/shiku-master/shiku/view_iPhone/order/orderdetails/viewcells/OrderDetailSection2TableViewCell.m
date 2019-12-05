//
//  OrderSection2TableViewCell.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderDetailSection2TableViewCell.h"

@implementation OrderDetailSection2TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textLabel1.textColor=MAIN_COLOR;
    self.textLabel2.textColor=TEXT_COLOR_DARK;
    
    self.iconView.layer.cornerRadius=10;
    self.iconView.backgroundColor=MAIN_COLOR;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, order)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}

- (void)unbind
{
}
- (void)render
{
    self.textLabel1.text=self.order.address_item.city_name;
    self.textLabel1.text=self.order.shipping_item.shipping_desc;
}

@end
