//
//  UIBindableTableViewCell.h
//  btc
//
//  Created by txj on 15/1/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIBindableTableViewCell <NSObject>

- (void)bind;//事件响应绑定
- (void)unbind;//废弃不用
@end
