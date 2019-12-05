//
//  MVVMViewModel.h
//  003--MVP
//
//  Created by chriseleee on 2018/8/29.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "PresentDalegate.h"
@interface MVVMViewModel : BaseViewModel<PresentDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

-(void)loadData;

#pragma mark 计算总数
-(int)total;

@end
