//
//  CategoryViewCL2CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewCL2CollectionViewCell : TUICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageHeight;

@property(strong,nonatomic) CATEGORY *category;

@end
