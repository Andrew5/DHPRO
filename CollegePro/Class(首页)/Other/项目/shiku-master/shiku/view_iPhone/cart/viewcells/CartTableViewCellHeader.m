//
//  CartTableViewCellHeader.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CartTableViewCellHeader.h"

@implementation CartTableViewCellHeader


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cellRect = self.frame;
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, cellRect.size.width, cellRect.size.height));
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = WHITE_COLOR;
    self.checkbox = [[QCheckBox alloc] initWithDelegate:self checkBoxIconSize:25];
    self.checkbox.frame = CGRectMake(10, 10, 25, 25);
    [self.checkbox setImage:[UIImage imageNamed:@"icon1_03"] forState:UIControlStateNormal];
    [self.checkbox setImage:[UIImage imageNamed:@"icon1_10"] forState:UIControlStateSelected];
    [self addSubview:self.checkbox];
    [self.checkbox setChecked:NO];
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    SEL selector = @selector(cartTableViewCellHeader:didSelect:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate cartTableViewCellHeader:self didSelect:checked];
    }
}

- (void)bind {
    @weakify(self)
    [RACObserve(self, shop_item)
            subscribeNext:^(id x) {
                @strongify(self);
                [self render];
            }];
    [RACObserve(self.shop_item, isSeleced)
            subscribeNext:^(id x) {
                @strongify(self);
                [self.checkbox setChecked:self.shop_item.isSeleced];
            }];
}

- (void)unbind {
}

- (void)render {
    self.nameLabel.text = self.shop_item.name;
    [self.checkbox setChecked:self.shop_item.isSeleced];
}

@end
