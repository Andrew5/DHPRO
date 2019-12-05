//
//  UDTableViewCell.m
//  Test
//
//  Created by Rillakkuma on 16/7/27.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "UDTableViewCell.h"

@implementation UDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView = backgroundView;
    self.contentView.backgroundColor = [UIColor greenColor];
    self.btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSelect.frame = CGRectMake( 15, 2, 30, 30);
    self.btnSelect.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:self.btnSelect];
    [self.btnSelect setTitle:@"⭕️" forState:UIControlStateNormal];
    self.btnSelect.titleLabel.font = [UIFont systemFontOfSize:20];
    self.btnSelect.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.btnSelect addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)selectAction:(id)sender{
    
    _customSelected = !_customSelected;
    if ([self.btnSelect.titleLabel.text isEqualToString:@"⭕️"]) {
        [self.btnSelect setTitle:@"🔴" forState:UIControlStateNormal];
    }else{
        [self.btnSelect setTitle:@"⭕️" forState:UIControlStateNormal];
    }
    !_customSelectedBlock ?: _customSelectedBlock(_customSelected, _row);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
