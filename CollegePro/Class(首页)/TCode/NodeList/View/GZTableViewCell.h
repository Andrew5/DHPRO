//
//  GZTableViewCell.h
//  GZTimeLine
//
//  Created by xinshijie on 2017/5/31.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZTimeLineModel.h"

@interface GZTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIView *point;
@property (strong, nonatomic)  UIView *GZTopLine;
@property (strong, nonatomic) UIView *GZBoyttomLine;
@property (nonatomic, strong)GZTimeLineModel *model;
@end
