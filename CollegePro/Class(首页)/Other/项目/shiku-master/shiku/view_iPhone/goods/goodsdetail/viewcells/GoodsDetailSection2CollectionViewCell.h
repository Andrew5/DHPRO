//
//  GoodsDetailSection2CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface GoodsDetailSection2CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *splitView;

@end
