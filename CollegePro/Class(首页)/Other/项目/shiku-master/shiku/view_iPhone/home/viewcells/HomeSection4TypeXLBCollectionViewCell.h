//
//  HomSection4CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/AdItem.h>

@interface HomeSection4TypeXLBCollectionViewCell : TUICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UIButton *btn_fav;
@property (weak, nonatomic) IBOutlet UIButton *btn_cart;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong,nonatomic) AdItem *aditem;
@end
