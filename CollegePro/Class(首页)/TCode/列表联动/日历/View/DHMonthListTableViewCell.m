//
//  DHMonthListTableViewCell.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/4.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHMonthListTableViewCell.h"

@implementation DHMonthListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor grayColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


@end
