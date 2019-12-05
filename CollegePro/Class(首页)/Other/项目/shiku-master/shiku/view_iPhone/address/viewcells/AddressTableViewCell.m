//
//  AddressTableViewCell.m
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.addressLabel.textColor=TEXT_COLOR_DARK;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, address)
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
    self.consigneeLabel.text=self.address.consignee;
    self.teleLabel.text=self.address.tel;
    self.addressLabel.text=[NSString stringWithFormat:@"%@%@%@%@,%@",self.address.province_name,self.address.city_name,self.address.district_name,self.address.address,self.address.zipcode];
    [self.addressLabel alignTop];
}
@end
