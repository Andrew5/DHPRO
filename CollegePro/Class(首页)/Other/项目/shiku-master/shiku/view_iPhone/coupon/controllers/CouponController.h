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

//优惠券

@protocol CouponControllerDelegate <NSObject>
@optional
- (void)didCouponSelected:(COLLECT_GOODS *)coupon;
@end

@interface CouponController : TBaseUIViewController <UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate>
{
    BOOL isHaveBackBtn;//是否是弹出页面
    NSMutableArray *favoriteList;
    int initType;
    TOTAL *mtotal;
}

-(instancetype)initWithBackBtn:(BOOL)isWithBack;
//从购物车初始化过来
-(instancetype)initWithCheckOut:(TOTAL *)total;


@property(nonatomic,retain)UITableView* tableView;
@property (strong, nonatomic) GOODS *product;
@property (nonatomic, strong) id<CouponControllerDelegate> delegate;
//过滤条件
@property (strong, nonatomic) FILTER *filter;
//后台对象
@property (strong, nonatomic) UserBackend *backend;
@property (nonatomic, weak) USER *user;
@end
