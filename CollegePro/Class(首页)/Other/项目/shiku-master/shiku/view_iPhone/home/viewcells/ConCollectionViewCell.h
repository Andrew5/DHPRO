//
//  ConCollectionViewCell.h
//  BlockPro
//
//  Created by Rilakkuma on 15/8/15.
//  Copyright (c) 2015年 Rilakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConCollectionViewCell : UICollectionViewCell
/**
 * 产品标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/**
 * 产品图片
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (weak, nonatomic) IBOutlet UIImageView *imageGoods;
/**
 * 产品销售
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSall;
/**
 * 产品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
/**
 * 购物车
 */
@property (weak, nonatomic) IBOutlet UIButton *btnCargoods;

+(instancetype)createCollectionView:(UICollectionView *)collectionView Index:(NSIndexPath *)indexPath;
@end
