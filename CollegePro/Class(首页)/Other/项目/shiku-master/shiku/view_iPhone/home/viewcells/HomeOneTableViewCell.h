//
//  HomeOneTableViewCell.h
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HomeOneTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
/**
 * 关注
 */
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
/**
 * banner图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
/**
 * 头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
/**
 * 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/**
 * 关注量
 */
@property (weak, nonatomic) IBOutlet UILabel *labelAttention;
/**
 * 销售量
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSalesVolume;
/**
 * 星星
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageStart;

@end
