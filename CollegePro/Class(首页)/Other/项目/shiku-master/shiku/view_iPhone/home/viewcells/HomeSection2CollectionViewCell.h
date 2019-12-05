//
//  HomeSection2CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/AdItem.h>

@interface HomeSection2CollectionViewCell : TUICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) AdItem *adItem;
@end
