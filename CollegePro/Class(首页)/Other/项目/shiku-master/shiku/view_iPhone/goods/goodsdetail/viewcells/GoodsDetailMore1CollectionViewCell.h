//
//  GoodsDetailMoreTab1Section0CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/21.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
*  cell模板，各属性请对照.xib文件
*/
@interface GoodsDetailMore1CollectionViewCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet UILabel *textLabel1;
@property(weak, nonatomic) IBOutlet UILabel *textLabel2;
@property(weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property(weak, nonatomic) IBOutlet UIView *bottomSplitView;
@property(weak, nonatomic) IBOutlet UIView *hSplitView;
@end