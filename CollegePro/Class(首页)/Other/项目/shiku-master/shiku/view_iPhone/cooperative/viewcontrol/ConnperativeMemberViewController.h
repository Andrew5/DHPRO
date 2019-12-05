//
//  ConnperativeMemberViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/8/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TBaseUIViewController.h"

@interface ConnperativeMemberViewController : TBaseUIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *vbackground;
/**
 * 社员贡献
 */
@property (strong, nonatomic) IBOutlet UILabel *labelMoney;
@property (copy,nonatomic)NSString *money;
/**
 * 社长优惠码
 */
@property (strong, nonatomic) IBOutlet UILabel *labelSociety;
@property (copy,nonatomic)NSString *scoiety;
/**
 * 底部view
 */
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
/**
 * 二维码
 */
@property (strong, nonatomic) IBOutlet UIImageView *imageViewDimensional;
/**
 * 招募数量
 */
@property (strong, nonatomic) IBOutlet UILabel *labelRecruit;
/**
 * 招募按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *btnRecruit;


@end
