//
//  HomeHeaderCollectionViewCell.h
//  BlockPro
//
//  Created by Rilakkuma on 15/8/15.
//  Copyright (c) 2015年 Rilakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeHeaderCollectionViewCellDelegate <NSObject>

- (void)attentionBack:(UIButton*)sender;

@end

@interface HomeHeaderCollectionViewCell : UICollectionViewCell
+(instancetype)createCollectionView:(UICollectionView *)collectionView Index:(NSIndexPath *)indexPath;
@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,weak)id<HomeHeaderCollectionViewCellDelegate>delegate;
/**
 * 边上的竖线
 */
@property (strong, nonatomic) IBOutlet UILabel *labelLine;
/**
 * 商品介绍图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
/**
 * 商品店铺名称
 */
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsShop;
/**
 * 关注数量
 */
@property (weak, nonatomic) IBOutlet UILabel *LabelAttention;
/**
 * 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
/**
 * 销售量
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSales;
/**
 * 评星展示
 */
@property (strong, nonatomic) IBOutlet UIImageView *imageStartone;
@property (strong, nonatomic) IBOutlet UIImageView *imageStarttwo;
@property (strong, nonatomic) IBOutlet UIImageView *imageStartthree;
@property (strong, nonatomic) IBOutlet UIImageView *imageStartfour;
@property (strong, nonatomic) IBOutlet UIImageView *imageStartfive;
/**
 * 关注按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *btnattention;
- (IBAction)actentionAction:(id)sender;

@end
