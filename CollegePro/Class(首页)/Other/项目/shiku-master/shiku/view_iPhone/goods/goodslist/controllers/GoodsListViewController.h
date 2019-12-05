//
//  GoodsListViewController.h
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/ThreeStageSegmentView.h>
#import "GoodsBackend.h"
#import "GoodsListTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "SearchViewController.h"
/**
 *  商品列表
 */
@interface GoodsListViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ThreeStageSegmentViewDelegate>
{
    UIButton *goTop;//返回顶部
    UIButton *topRightBtn;
    UILabel *lbCartBadge;
}

@property (weak, nonatomic) IBOutlet UIView *threeSegmentBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* datalist;
@property (strong, nonatomic) GoodsBackend *backend;
@property (strong, nonatomic) FILTER *filter;
@property (strong, nonatomic) CATEGORY *category;
@property (nonatomic, weak) USER *user;
/**
 *  通过过滤器初始化商品列表
 *
 */
-(instancetype)initWithFilter:(FILTER *)anFilter;
/**
 *  通过商品类别初始化商品列表
 */
-(instancetype)initWithCategory:(CATEGORY *)anCategory;

@end
