//
//  relateTableViewCell.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/30.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface relateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *cname;
@property (weak, nonatomic) IBOutlet UILabel *ename;
@property (weak, nonatomic) IBOutlet UILabel *where;

@property (weak, nonatomic) IBOutlet UILabel *time;
@end
