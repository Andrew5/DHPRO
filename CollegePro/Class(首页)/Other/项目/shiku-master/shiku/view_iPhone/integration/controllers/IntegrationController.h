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

/**
 *  积分信息
 */

@interface IntegrationController : TBaseUIViewController <UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate>
{
    BOOL isHaveBackBtn;//导航栏里是否包含返回按钮
    NSMutableArray *favoriteList;
    
}
/**
 *  根据是否需要导航按钮进行初始化
 *
 *  @param isWithBack BOOL类型
 *
 *  @return
 */
-(instancetype)initWithBackBtn:(BOOL)isWithBack;
@property(nonatomic,retain)UITableView* tableView;
@property (strong, nonatomic) GOODS *product;//商品信息

@property (strong, nonatomic) FILTER *filter;//过滤信息
@property (strong, nonatomic) UserBackend *backend;
@property (nonatomic, weak) USER *user;
@end
