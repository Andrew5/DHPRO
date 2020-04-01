//
//  UITableView+DHAnimationA.m
//  CollegePro
//
//  Created by jabraknight on 2020/4/1.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "UITableView+DHAnimationA.h"
#import "TableViewAnimationA.h"

@implementation UITableView (DHAnimationA)
- (void)dhShowTableViewAnimationWithType:(DHTableViewAnimationType )animationType{
    [TableViewAnimationA showWithAnimationType:animationType tableView:self];
}

@end
