//
//  AddressBookView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/25.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "AddressBookView.h"

@implementation AddressBookView


-(void)layoutView:(CGRect)frame
{
    self.tableView = [[UITableView alloc]initWithFrame:frame];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:self.tableView];
    [self addSubview:self.tableView];
  
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];

}

@end
