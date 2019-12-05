//
//  MyfarmTableViewCell.h
//  shiku
//
//  Created by Rilakkuma on 15/9/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGetdata.h"

@protocol MyfarmTableViewCellDelegate <NSObject>
- (void)shareGoods:(MyfarNSObject *)model;

@end

@interface MyfarmTableViewCell : UITableViewCell<MyfarmTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) MyfarNSObject *model;
@property (strong, nonatomic) IBOutlet UILabel *labelSubtitle;
@property(nonatomic, strong) id <MyfarmTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
