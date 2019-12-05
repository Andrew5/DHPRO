//
//  HomeThreeTableViewCell.h
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gooleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGoodcar;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelShoppingNum;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;



+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
