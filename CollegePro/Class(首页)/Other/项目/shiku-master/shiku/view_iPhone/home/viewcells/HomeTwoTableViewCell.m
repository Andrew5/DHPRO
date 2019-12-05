//
//  HomeTwoTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeTwoTableViewCell.h"


@implementation HomeTwoTableViewCell
- (void)awakeFromNib {


    
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeTwoTableViewCell";
    HomeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTwoTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
