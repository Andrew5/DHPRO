//
//  LMDataSource.h
//  LMShopCart
//
//  Created by Cooci on 2018/3/29.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CellConfigureBefore)(id cell, id model, NSIndexPath * indexPath);
typedef void (^selectCell) (NSIndexPath *indexPath);
typedef void (^reloadData) (NSMutableArray *array);

@interface LMDataSource : NSObject<UITableViewDataSource,UICollectionViewDataSource,UITableViewDelegate,UICollectionViewDelegate>

@property (nonatomic, strong)  NSMutableArray *dataArray;;

//自定义
- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before selectBlock:(selectCell)selectBlock reloadData:(reloadData)reloadData;





- (void)addDataArray:(NSArray *)datas;

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;

@end
