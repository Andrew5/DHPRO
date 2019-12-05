//
//  ExponsionCell1.m
//  Znaer
//
//  Created by Jeremy on 14-6-24.
//  Copyright (c) 2014年 Jeremy. All rights reserved.
//

#import "ExponsionCell1.h"

@implementation ExponsionCell1

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"UpAccessory.png"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"DownAccessory.png"];
    }
}


@end
