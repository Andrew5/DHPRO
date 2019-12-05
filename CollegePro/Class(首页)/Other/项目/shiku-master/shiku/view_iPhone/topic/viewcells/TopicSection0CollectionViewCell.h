//
//  TopicSection0CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface TopicSection0CollectionViewCell : TUICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (strong,nonatomic) CATEGORY *category;
@end
