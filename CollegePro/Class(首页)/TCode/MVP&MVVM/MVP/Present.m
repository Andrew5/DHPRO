//
//  Present.m
//  003--MVP
//
//  Created by Cooci on 2018/4/1.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "Present.h"

@implementation Present

#pragma mark - lazy

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}

- (instancetype)init{
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}


- (void)loadData{
    
    NSArray *temArray =
    @[
      @{@"name":@"火车",@"imageUrl":@"http://CC",@"num":@"1"},
      @{@"name":@"飞机",@"imageUrl":@"http://James",@"num":@"1"},
      @{@"name":@"跑车",@"imageUrl":@"http://Gavin",@"num":@"1"},
      @{@"name":@"女票",@"imageUrl":@"http://Cooci",@"num":@"1"},
      @{@"name":@"男票",@"imageUrl":@"http://Dean ",@"num":@"1"},
      @{@"name":@"滑板",@"imageUrl":@"http://CC",@"num":@"1"},
      @{@"name":@"一日游",@"imageUrl":@"http://James",@"num":@"1"}];
    for (int i = 0; i<temArray.count; i++) {
        Model *m = [Model mj_objectWithKeyValues:temArray[i]];
        [self.dataArray addObject:m];
    }
}


#pragma mark - PresentDelegate
- (void)didClickAddBtnWithNum:(NSString *)num indexPath:(NSIndexPath *)indexPath{

    for (int i = 0; i<self.dataArray.count; i++) {
        // 查数据 ---> 钱
        if (i == indexPath.row) {// 商品ID 容错
            Model *m = self.dataArray[indexPath.row];
            m.num    = num;
            break;
        }
    }
    
    if ([num intValue] > 6) {
        NSArray *temArray =
        @[
          @{@"name":@"火车",@"imageUrl":@"http://CC",@"num":@"6"},
          @{@"name":@"飞机",@"imageUrl":@"http://James",@"num":@"6"},
          @{@"name":@"跑车",@"imageUrl":@"http://Gavin",@"num":@"6"},
          @{@"name":@"女票",@"imageUrl":@"http://Cooci",@"num":@"6"},
          @{@"name":@"男票",@"imageUrl":@"http://Dean ",@"num":@"6"},
          @{@"name":@"滑板",@"imageUrl":@"http://CC",@"num":@"6"},
          @{@"name":@"一日游",@"imageUrl":@"http://James",@"num":@"6"}];
        [self.dataArray removeAllObjects];
        for (int i = 0; i<temArray.count; i++) {
            Model *m = [Model mj_objectWithKeyValues:temArray[i]];
            [self.dataArray addObject:m];
        }

    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataForUI)]) {
        [self.delegate reloadDataForUI];
    }
}

#pragma mark 计算总数
-(int)total{
    int total = 0;
    for (Model* dic in self.dataArray) {
        int num = [dic.num intValue];
        total += num;
    }
    return total;
}

@end
