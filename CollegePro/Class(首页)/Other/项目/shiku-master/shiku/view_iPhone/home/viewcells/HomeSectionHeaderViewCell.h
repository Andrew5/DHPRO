//
//  HomeSectionHeaderViewCell.h
//  btc
//
//  Created by txj on 15/2/5.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBindableTableViewCell.h"
/**
 *  首页最上方滚动广告
 */
@interface HomeSectionHeaderViewCell : UICollectionReusableView<UIBindableTableViewCell>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *strtext;
@end
