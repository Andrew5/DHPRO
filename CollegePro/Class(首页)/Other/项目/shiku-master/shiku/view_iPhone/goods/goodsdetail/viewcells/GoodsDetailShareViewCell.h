//
//  GoodsDetailShareViewCell.h
//  shiku
//
//  Created by Brivio Wang on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TUICollectionViewCell.h"

@protocol GoodsDetailShareViewCellDelegate <NSObject>
- (void)shareGoods;
@end

@interface GoodsDetailShareViewCell : TUICollectionViewCell
@property(weak, nonatomic) IBOutlet UILabel *rateTitle;
@property(weak, nonatomic) IBOutlet UILabel *saleTitle;

@property(weak, nonatomic) IBOutlet UILabel *rateLable;
@property(weak, nonatomic) IBOutlet UILabel *saleLable;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@property(strong, nonatomic) GOODS *goods;
@property(nonatomic, strong) id <GoodsDetailShareViewCellDelegate> delegate;
@end
