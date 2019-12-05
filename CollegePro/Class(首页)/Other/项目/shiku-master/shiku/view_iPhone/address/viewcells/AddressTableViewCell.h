//
//  AddressTableViewCell.h
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface AddressTableViewCell : SWTableViewCell<UIBindableTableViewCell>
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) ADDRESS* address;//ADDRESS
@end
