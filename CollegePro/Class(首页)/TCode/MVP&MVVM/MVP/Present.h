//
//  Present.h
//  003--MVP
//
//  Created by Cooci on 2018/4/1.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "PresentDalegate.h"

@interface Present : NSObject<PresentDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;

// 根据需求
- (void)loadData;

@property (nonatomic, weak) id<PresentDelegate> delegate;

#pragma mark 计算总数
-(int)total;

@end
