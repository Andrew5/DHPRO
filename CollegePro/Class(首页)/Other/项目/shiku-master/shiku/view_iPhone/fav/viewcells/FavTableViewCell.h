//
//  FavTableViewCell.h
//  btc
//
//  Created by txj on 15/3/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "UIBindableTableViewCell.h"

@interface FavTableViewCell : SWTableViewCell<UIBindableTableViewCell>
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopname;
@property (weak, nonatomic) IBOutlet UILabel *subtitle1;
@property (weak, nonatomic) IBOutlet UILabel *subtitle2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageWidth;

@property (strong, nonatomic) COLLECT_GOODS *goods;
@end
