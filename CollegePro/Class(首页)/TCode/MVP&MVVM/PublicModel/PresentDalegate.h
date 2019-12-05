//
//  PresentDalegate.h
//  003--MVP
//
//  Created by chriseleee on 2018/8/27.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PresentDelegate<NSObject>

@optional
// 刷新UI  ---> tableView VC
- (void)reloadDataForUI;

// 解耦
// 需求 : 需求驱动代码  清晰
// 维护 : 快

// UI ---> model
- (void)didClickAddBtnWithNum:(NSString *)num indexPath:(NSIndexPath *)indexPath;

@end
