//
//  HomeInfomanagerViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeInfomanagerViewController : UITableViewCell
/**
 * 评论标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
/**
 * 商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGoods;

@property (nonatomic,strong)NSDictionary *imageDic;

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)loadData;
@end
