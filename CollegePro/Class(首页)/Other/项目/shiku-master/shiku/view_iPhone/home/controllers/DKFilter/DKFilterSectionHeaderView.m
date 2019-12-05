//
//  DKFilterSectionHeaderView.m
//  Partner
//
//  Created by Drinking on 15-1-5.
//  Copyright (c) 2015年 zhinanmao.com. All rights reserved.
//

#import "DKFilterSectionHeaderView.h"

@implementation DKFilterSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSectionHeaderTitle:(NSString *)title{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil];
}
@end
