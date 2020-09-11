//
//  WKVCDeallocCell.h
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKDeallocModel;
@protocol WKVCDeallocCellDelegate <NSObject>

- (void)clickWithImg:(UIImage *)img;

@end

@interface WKVCDeallocCell : UITableViewCell

@property (nonatomic, strong) WKDeallocModel * model;
@property (nonatomic, weak) id<WKVCDeallocCellDelegate> delegate;
@end
