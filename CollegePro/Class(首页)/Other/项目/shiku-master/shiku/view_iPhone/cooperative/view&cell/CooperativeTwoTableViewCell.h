//
//  CooperativeTwoTableViewCell.h
//  shiku
//
//  Created by Rilakkuma on 15/8/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CooperativeTwoTableViewCell : UITableViewCell
/**
 * 备注
 */
@property (strong, nonatomic) IBOutlet UILabel *labelContribute;
/**
 * 时间
 */
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
/**
 * 标题
 */
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
/**
 * 头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
