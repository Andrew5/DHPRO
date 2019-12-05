//
//  NobodyNibTableTableViewCell.h
//  Test
//
//  Created by Rillakkuma on 2016/12/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiParamButton.h"
#import "SYAccountListCellDelegate.h"
// 一会要传的值为NSString类型
typedef void (^newBlock)(NSString *);

@interface NobodyNibTableTableViewCell : UITableViewCell
@property(nonatomic,retain)MultiParamButton* multiParamButton;
@property (nonatomic,weak)id<SYAccountListCellDelegate>delegate;

@property (nonatomic, copy) newBlock block;
@end
