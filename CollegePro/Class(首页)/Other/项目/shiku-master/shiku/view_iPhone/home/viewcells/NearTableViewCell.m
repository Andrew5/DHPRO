//
//  NearTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/8/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "NearTableViewCell.h"

@implementation NearTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"NearTableViewCell";
    NearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NearTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
