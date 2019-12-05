//
//  FavViewController.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBackend.h"
#import "GoodsBackend.h"
#import "GoodsDetailViewController.h"

//农户
@interface FavViewController : TBaseUIViewController <UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate>
{
    BOOL isHaveBackBtn;
    NSMutableArray *favoriteList;
    
}
/**
 *  如果是弹出页面，调用此初始化函数
 *
 *  @param isWithBack
 *
 */
-(instancetype)initWithBackBtn:(BOOL)isWithBack;
@property(nonatomic,retain)UITableView* tableView;
@property (strong, nonatomic) GOODS *product;

@property (strong, nonatomic) FILTER *filter;
@property (strong, nonatomic) UserBackend *backend;
@property (nonatomic, weak) USER *user;
@end
