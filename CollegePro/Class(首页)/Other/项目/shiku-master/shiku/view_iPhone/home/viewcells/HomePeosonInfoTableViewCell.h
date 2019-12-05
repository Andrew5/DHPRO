//
//  HomePeosonInfoTableViewCell.h
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePeosonInfoTableViewCellDelegate <NSObject>

- (void)attentionAction:(UIButton*)sender;

@end

@interface HomePeosonInfoTableViewCell : UITableViewCell

@property (nonatomic,weak)id <HomePeosonInfoTableViewCellDelegate>delegate;
/**
 * 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/**
 * 地址
 */
@property (weak, nonatomic) IBOutlet UILabel *labelAdress;
/**
 * 关注
 */
@property (weak, nonatomic) IBOutlet UILabel *labelAttention;
/**
 * 销售
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSales;
/**
 * 关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
/**
 * 头像图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
/**
 * 农户姓名
 */
@property (strong, nonatomic) IBOutlet UILabel *labelmname;

/**
 * 评星展示
 */
@property (strong, nonatomic) IBOutlet UIImageView *imageStartone;
@property (strong, nonatomic) IBOutlet UIImageView *imageStarttwo;
@property (strong, nonatomic) IBOutlet UIImageView *imageStartthree;
@property (strong, nonatomic) IBOutlet UIImageView *imageStartfour;
@property (strong, nonatomic) IBOutlet UIImageView *imageStartfive;

- (IBAction)attentionAction:(id)sender;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
