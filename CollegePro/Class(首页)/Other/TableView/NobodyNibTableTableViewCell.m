//
//  NobodyNibTableTableViewCell.m
//  Test
//
//  Created by Rillakkuma on 2016/12/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "NobodyNibTableTableViewCell.h"

@implementation NobodyNibTableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		// cell页面布局
		[self setupView];
		self.contentView.backgroundColor = [UIColor redColor];
	}
	return self;
}
- (void)setupView{
	NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:3];
	CGRect btnRect = CGRectMake(DH_DeviceWidth/2-50, 5, 60, 20);
	for (NSString* optionTitle in @[@"正常", @"故障"]) {
		UIButton* btn = [[UIButton alloc] initWithFrame:btnRect];
		[btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
		btnRect.origin.y += 23;
		btn.titleLabel.font = [UIFont systemFontOfSize:14];
		[btn setTitle:optionTitle forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
		btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
		[self.contentView addSubview:btn];
		[buttons addObject:btn];
	}
	
}
- (void)onRadioButtonValueChanged:(UIButton *)sender{
	if (self.block != nil) {
		self.block(sender.currentTitle);
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
