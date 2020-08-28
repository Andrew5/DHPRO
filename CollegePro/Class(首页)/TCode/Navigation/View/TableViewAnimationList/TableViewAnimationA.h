//
//  TableViewAnimationA.h
//  CollegePro
//
//  Created by jabraknight on 2020/4/1.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewAnimationKitConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewAnimationA : NSObject
+ (void)showWithAnimationType:(DHTableViewAnimationType)animationType tableView:(UITableView *)tableView;
+ (void)moveAnimationWithTableView:(UITableView *)tableView;
+ (void)moveSpringAnimationWithTableView:(UITableView *)tableView;
+ (void)alphaAnimationWithTableView:(UITableView *)tableView;
+ (void)fallAnimationWithTableView:(UITableView *)tableView;
+ (void)shakeAnimationWithTableView:(UITableView *)tableView;
+ (void)overTurnAnimationWithTableView:(UITableView *)tableView;
+ (void)toTopAnimationWithTableView:(UITableView *)tableView;
+ (void)springListAnimationWithTableView:(UITableView *)tableView;
+ (void)shrinkToTopAnimationWithTableView:(UITableView *)tableView;
+ (void)layDownAnimationWithTableView:(UITableView *)tableView;
+ (void)roteAnimationWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
