//
//  UserLikeViewController.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBackend.h"
#import "UserLikeTableViewCell.h"
#import "GoodsDetailViewController.h"
/**
 *  喜欢
 */
@interface UserLikeViewController : TBaseUIViewController<UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate,UserLikeTableViewCellDelegate>
{
    NSMutableArray *userLikeList;
    BOOL isHaveBackBtn;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FILTER *filter;
@property (strong, nonatomic) UserBackend *backend;
@property (nonatomic, weak) USER *user;
-(instancetype)initWithBackBtn:(BOOL)isWithBack;
@end
