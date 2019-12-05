//
//  CategoryViewCL2CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface GradeCollectionV2ViewCell : TUICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageHeight;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *cimageView;
@property (weak, nonatomic) IBOutlet UIView *cCoverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cimageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cimageViewWidth;

@property(strong,nonatomic) CATEGORY *category;

@end
