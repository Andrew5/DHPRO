//
//  GoodsDetailMoreViewController.h
//  shiku
//
//  Created by txj on 15/5/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailSection2CollectionViewCell.h"
#import "GoodsDetailMore1CollectionViewCell.h"
#import "GoodsDetailMore2CollectionViewCell.h"
#import "GoodsBackend.h"
#import "GoodsDetailMoreHeaderCollectionReusableView.h"
#import "GoodsDetailMoreLogListCollectionViewCell.h"
#import "GoodsDetailMoreLogInfoListCollectionViewCell.h"
#import "GoodsDetailMoreWebViewCollectionViewCell.h"

/**
 *  商品详情更过
 */
@interface GoodsDetailMoreViewController : TBaseUIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    NSInteger currentTab;
    NSArray *itemtitles;
    NSArray *itemicons;
    NSArray *itemiconsselect;
    GoodsDetailSection2CollectionViewCell *firstcell;
    NSArray *currDetailInfo;
    UIButton *anbtn;//top按钮

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (strong, nonatomic) GoodsBackend *backend;
@property (strong, nonatomic) GOODS *goods;
@property (strong, nonatomic) GOODS_DETAIL_INFO *goods_detail_info;

-(instancetype)initWithGoods:(GOODS *)anGoods andTabIndex:(NSInteger)index;
@end
