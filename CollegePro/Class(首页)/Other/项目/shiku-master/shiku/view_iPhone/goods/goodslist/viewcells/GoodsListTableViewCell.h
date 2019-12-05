//
//  UserLikeTableViewCell.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@protocol GoodsListTableViewCellDelegate <NSObject>

-(void)didSharedBtnTapped:(COLLECT_GOODS *) goods;

@end
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface GoodsListTableViewCell : SWTableViewCell<UIBindableTableViewCell>


@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIButton *btnShared;

- (IBAction)btnSharedTapped:(id)sender;

@property (strong, nonatomic) id<GoodsListTableViewCellDelegate> ulDelegate;
@property (strong, nonatomic) COLLECT_GOODS *goods;
@end
