//
//  ExpandCell.m
//  点击按钮出现下拉列表
//
//  Created by 杜甲 on 14-3-26.
//  Copyright (c) 2014年 杜甲. All rights reserved.
//

#import "ExpandCell.h"

@implementation ExpandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
//        self.backgroundColor = [UIColor clearColor];
        self.m_TileL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        self.m_TileL.textAlignment = NSTextAlignmentRight;
        self.m_TileL.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.m_TileL];
    }
    return self;
}

-(void)setCellContentData:(NSString*)name
{
    self.m_TileL.text = name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
