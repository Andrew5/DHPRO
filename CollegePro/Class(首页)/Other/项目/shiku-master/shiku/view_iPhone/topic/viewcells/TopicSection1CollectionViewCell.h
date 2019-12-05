//
//  TopicSection2CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface TopicSection1CollectionViewCell : TUICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel3;

@property (strong,nonatomic) CATEGORY *category;

@end
