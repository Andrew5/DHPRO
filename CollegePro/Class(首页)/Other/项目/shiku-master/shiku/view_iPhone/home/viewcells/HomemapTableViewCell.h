//
//  HomemapTableViewCell.h
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomemapTableViewCell : UITableViewCell
/**
 * 地址
 */
@property (weak,nonatomic)IBOutlet UILabel *labelAdress;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMap;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
