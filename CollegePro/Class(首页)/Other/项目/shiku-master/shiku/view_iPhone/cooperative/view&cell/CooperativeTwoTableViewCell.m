//
//  CooperativeTwoTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/8/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CooperativeTwoTableViewCell.h"

@implementation CooperativeTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 30;
    [_iconImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _iconImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;

    
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CooperativeTwoTableViewCell";
    CooperativeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CooperativeTwoTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
