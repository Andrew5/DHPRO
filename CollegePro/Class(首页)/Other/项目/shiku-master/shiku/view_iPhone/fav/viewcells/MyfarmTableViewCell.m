//
//  MyfarmTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/9/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "MyfarmTableViewCell.h"
@implementation MyfarmTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_btnShare addTarget:self action:@selector(shareHandlerS) forControlEvents:UIControlEventTouchUpInside];

}
- (void)shareHandlerS {
    [[self delegate] shareGoods:_model];
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MyfarmTableViewCell";
    MyfarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyfarmTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
