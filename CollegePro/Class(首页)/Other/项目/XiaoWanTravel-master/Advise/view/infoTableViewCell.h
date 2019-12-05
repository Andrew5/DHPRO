//
//  infoTableViewCell.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/30.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
@interface infoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;
-(void)setModel:(detailModel *)model;
@end
