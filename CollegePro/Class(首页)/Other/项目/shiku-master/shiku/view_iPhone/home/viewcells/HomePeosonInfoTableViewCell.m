//
//  HomePeosonInfoTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomePeosonInfoTableViewCell.h"

@implementation HomePeosonInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _btnAttention.layer.cornerRadius = 3;
}
- (IBAction)attentionAction:(id)sender {
    [self.delegate attentionAction:sender];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomePeosonInfoTableViewCell";
    HomePeosonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomePeosonInfoTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
