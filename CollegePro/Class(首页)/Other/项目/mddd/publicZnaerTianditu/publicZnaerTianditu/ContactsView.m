//
//  ContactsView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "ContactsView.h"

@implementation ContactsView
@synthesize tableview;
@synthesize searchBar;


-(void)layoutView:(CGRect)frame{
    
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.0f)];
    
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - self.NavigateBarHeight - 49)];
    tableview.contentOffset =  CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
    tableview.tableHeaderView = searchBar;
//    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
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
