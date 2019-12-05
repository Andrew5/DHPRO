//
//  HomeSection3CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/AdItem.h>

@interface HomeSection3CollectionViewCell : TUICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageView2Width;
@property (strong,nonatomic) AdItem *aditem1;
@property (strong,nonatomic) AdItem *aditem2;
@end
