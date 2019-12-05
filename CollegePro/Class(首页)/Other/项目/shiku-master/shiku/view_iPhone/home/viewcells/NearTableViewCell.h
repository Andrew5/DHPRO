//
//  NearTableViewCell.h
//  shiku
//
//  Created by Rilakkuma on 15/8/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
/**
 * 商品图
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageGoods;
/**
 * 商品标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsTitle;

/**
 * 距离显示
 */
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;

/**
 * 评分
 */
@property (weak, nonatomic) IBOutlet UILabel *labelMark;

/**
 * 评分数
 */
@property (weak, nonatomic) IBOutlet UILabel *labelMarlNum;

/**
 * 主营
 */
@property (weak, nonatomic) IBOutlet UILabel *labelManage;

/**
 * 主营标签
 */
@property (weak, nonatomic) IBOutlet UILabel *labelManagetitle;

/**
 * 销量
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSales;

/**
 * 销量数
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSalesNum;

/**
 * 产地
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPlace;

/**
 * 产地名称
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceTitle;


//
@end
