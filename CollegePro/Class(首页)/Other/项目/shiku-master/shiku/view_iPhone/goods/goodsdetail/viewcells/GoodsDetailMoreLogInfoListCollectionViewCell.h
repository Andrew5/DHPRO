//
//  GoodsDetailMoreLogInfoListCollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/22.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface GoodsDetailMoreLogInfoListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *splitView1;
@property (weak, nonatomic) IBOutlet UILabel *textLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *textLabelbuttom;
@property (weak, nonatomic) IBOutlet UILabel *textLabelCenter;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
