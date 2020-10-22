//
//  JPShopCarController.h
//  回家吧
//
//  Created by 王洋 on 16/3/25.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPShopCarController : BaseViewController
@property(nonatomic,strong) NSMutableArray *allSelectedDataArray;

@property(nonatomic,strong) NSString *H5Url;

//@property(nonatomic,strong) WVNode *wvnode;

@property(nonatomic,strong) NSString *selectMax;

@property(nonatomic,strong) NSString *selectMaxSize;


- (void)updateSendData;

//- (void)getModelWvnode:(WVNode *)wvnode;

- (void)getSelectMax:(NSString *)max;//最大上传个数

- (void)getSelectMaxSize:(NSString *)maxSize;//最大上传大小
@end
