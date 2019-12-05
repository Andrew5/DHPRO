//
//  DataModel.m
//  Test
//
//  Created by Rillakkuma on 2017/8/11.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
-(instancetype)init{
	self = [super init];
	if (self) {
		NSArray *arr_Photos = self.Comments;
		NSLog(@"---%@",arr_Photos);
//		[_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//			NSDictionary *dict_data = _dataSource[idx];
//			NSArray *Photos = dict_data[@"Photos"];
//			NSLog(@"图片:%@",Photos);
//			NSArray *eachArr = dict_data[@"Comments"];
//			
//		}];

	}
	return self;
}
//- (void)alloc{
//    NSLog(@"alloc接收到网络测试的model");
//}
- (void)teset{
    NSLog(@"teset接收到网络测试的model");
}
@end
