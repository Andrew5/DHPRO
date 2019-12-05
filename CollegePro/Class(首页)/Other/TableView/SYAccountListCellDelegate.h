//
//  SYAccountListCellDelegate.h
//  Test
//
//  Created by Rillakkuma on 2016/12/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MultiParamButton;
@class NobodyNibTableTableViewCell;
@protocol SYAccountListCellDelegate <NSObject>
- (void)accountListCell:(NobodyNibTableTableViewCell* )cell didTapButton:(MultiParamButton* )button;

@end
