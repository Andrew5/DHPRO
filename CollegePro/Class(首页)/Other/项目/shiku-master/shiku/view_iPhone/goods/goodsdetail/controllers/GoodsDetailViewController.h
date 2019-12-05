//
//  GoodsListViewController.h
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailSection0CollectionViewCell.h"
#import "GoodsDetailSection1CollectionViewCell.h"
#import "GoodsDetailSection2CollectionViewCell.h"
#import "GoodsDetailSection3CollectionViewCell.h"
#import "GoodsDetailSection4CollectionViewCell.h"
#import "GoodsBackend.h"
#import "UserBackend.h"
#import "CartBackend.h"
#import "GoodsDetailMoreViewController.h"
#import "GoodsDetailMenuViewController.h"
#import "UserLoginViewController.h"
#import "GoodsDetailShareViewCell.h"


/**
*  商品详情页面
*/
@interface GoodsDetailViewController : TBaseUIViewController <
        UICollectionViewDataSource,
        UICollectionViewDelegate,
        UICollectionViewDelegateFlowLayout,
        UIScrollViewDelegate,
        GoodsDetailMenuViewControllerDelegate,
        GoodsDetailSection1CollectionViewCellDelegate,
        GoodsDetailShareViewCellDelegate,
        UserLoginViewControllerDelegate,
        UITextFieldDelegate> {
    NSArray *sectionCells;
    NSArray *section2icons;
    NSArray *section2titles;
    UIView *bottomBarContainer;
    CGRect collectionViewFrame;
            /**
             * 添加通知信息
             */
            UILabel *lbCartBadge;
            UIButton *anbtn;//top按钮

}
- (instancetype)initWithGoods:(GOODS *)anGoods;

@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) UserBackend *userBackend;
@property(strong, nonatomic) GoodsBackend *backend;
@property(nonatomic, strong) NSNumber *goods_id;
@property(nonatomic, strong) GOODS *goods;
@property(nonatomic, strong) USER *user;
@property(nonatomic, strong) CartBackend *cartBackend;
@property (strong, nonatomic) CART_GOODS *cartItem;
@property(strong, nonatomic) GOODS_DETAIL_INFO *goods_detail_info;
@property (nonatomic,assign)BOOL FromCartVC;
@property (nonatomic,assign)BOOL fromHomeNew;
@property (nonatomic,assign)NSString* mid;
@end
