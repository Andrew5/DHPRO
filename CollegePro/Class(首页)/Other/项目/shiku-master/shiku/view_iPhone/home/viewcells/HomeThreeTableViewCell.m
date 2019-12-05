//
//  HomeThreeTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeThreeTableViewCell.h"

@implementation HomeThreeTableViewCell

- (void)awakeFromNib {
    [_gooleImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _gooleImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _gooleImageView.contentMode = UIViewContentModeScaleAspectFill;
    _gooleImageView.clipsToBounds = YES;
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeThreeTableViewCell";
    HomeThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeThreeTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
