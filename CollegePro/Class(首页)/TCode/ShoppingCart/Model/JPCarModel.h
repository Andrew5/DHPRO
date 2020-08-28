//
//  JPCarModel.h
//  回家吧
//
//  Created by 王洋 on 16/3/28.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPCarModel : NSObject

/**商品是否被选中*/
@property (nonatomic, assign, getter=isSelected) BOOL selected;
/**商店是否被选中*/ // 选中商店下边的所有商品
@property (nonatomic, assign, getter=isAllSelect) BOOL allSelect;

/**商品标题*/
@property (nonatomic, copy) NSString *name;
/**商品图标*/
@property (nonatomic, copy) NSString *icon;
/**商品单价*/
@property (nonatomic, copy) NSString *price;
/**购买数量*/
@property (nonatomic, assign) int buyCount;

@property (nonatomic, copy) NSMutableArray *numArray; // 存放商品个数


@end
