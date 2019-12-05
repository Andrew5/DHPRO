//
//  HomemapTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomemapTableViewCell.h"

@implementation HomemapTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomemapTableViewCell";
    HomemapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomemapTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
