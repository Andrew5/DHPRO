//
//  UserLikeTableViewCell.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
/**
 *  cell模板，各属性请对照.xib文件
 */
@protocol UserLikeTableViewCellDelegate <NSObject>

-(void)didSharedBtnTapped:(COLLECT_GOODS *) goods;

@end

@interface UserLikeTableViewCell : SWTableViewCell<UIBindableTableViewCell>


@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnShared;

- (IBAction)btnSharedTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (strong, nonatomic) id<UserLikeTableViewCellDelegate> ulDelegate;
@property (strong, nonatomic) COLLECT_GOODS *goods;
@end
