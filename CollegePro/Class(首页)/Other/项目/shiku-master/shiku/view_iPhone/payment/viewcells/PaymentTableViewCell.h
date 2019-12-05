//
//  PaymentTableViewCell.h
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface PaymentTableViewCell : TUITableViewCell
@property (strong, nonatomic) ORDER_INFO *orderInfo;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setCellContent:(NSString *)text withImageName:(NSString *)imagename;
@end
