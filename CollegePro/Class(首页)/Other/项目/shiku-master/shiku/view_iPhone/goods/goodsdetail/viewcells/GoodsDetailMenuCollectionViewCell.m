//
//  GoodsDetailMenuCollectionViewCell.m
//  shiku
//
//  Created by txj on 15/5/21.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsDetailMenuCollectionViewCell.h"

@implementation GoodsDetailMenuCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius=5;
    self.layer.borderWidth=1;
    self.layer.borderColor=BG_COLOR.CGColor;
}

@end
