//
//  GoodsDetailAvatarViewCell.h
//  shiku
//
//  Created by Brivio Wang on 15/7/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TUICollectionViewCell.h"

@interface GoodsDetailAvatarViewCell : TUICollectionViewCell
@property(weak, nonatomic) IBOutlet UILabel *textLabel1;
@property(weak, nonatomic) IBOutlet UILabel *textLabel2;
@property(weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property(weak, nonatomic) IBOutlet UIView *bottomSplitView;
@property(weak, nonatomic) IBOutlet UIView *hSplitView;
@end
