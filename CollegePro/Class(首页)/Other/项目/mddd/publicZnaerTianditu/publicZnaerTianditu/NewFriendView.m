//
//  NewFriendView.m
//  publicZnaer
//
//  Created by 吴小星 on 15-1-8.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "NewFriendView.h"

@implementation NewFriendView
@synthesize tableview;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self layoutView];
    }
    return self;
}

-(void)layoutView{
    tableview=[[UITableView alloc]initWithFrame:self.frame];
    [self setExtraCellLineHidden:tableview];
    [self addSubview:tableview];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

@end
