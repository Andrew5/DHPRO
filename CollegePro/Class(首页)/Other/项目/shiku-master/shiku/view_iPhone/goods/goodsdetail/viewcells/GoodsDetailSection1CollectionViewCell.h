//
//  GoodsDetailSection1CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDetailSection1CollectionViewCell;
@class UICustomLineLabel;

@protocol GoodsDetailSection1CollectionViewCellDelegate <NSObject>
@optional
@end

/**
*  cell模板，各属性请对照.xib文件
*/
@interface GoodsDetailSection1CollectionViewCell : TUICollectionViewCell
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UICustomLineLabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property(nonatomic, strong) id <GoodsDetailSection1CollectionViewCellDelegate> delegate;
@property(strong, nonatomic) GOODS *goods;

@end
