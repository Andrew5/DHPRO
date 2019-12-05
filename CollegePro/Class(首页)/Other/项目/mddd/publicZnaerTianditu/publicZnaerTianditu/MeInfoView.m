//
//  MeInfoView.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/20.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "MeInfoView.h"

@implementation MeInfoView
@synthesize tableview;

-(void)layoutView:(CGRect)frame{
    
    tableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableview.backgroundColor = [self retRGBColorWithRed:232 andGreen:232 andBlue:232];
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
