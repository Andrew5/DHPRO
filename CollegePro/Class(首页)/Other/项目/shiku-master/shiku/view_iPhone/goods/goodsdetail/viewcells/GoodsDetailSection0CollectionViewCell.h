//
//  GoodsDetailSection0CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/PagePhotosView.h>

/**
 *  cell模板，各属性请对照.xib文件
 */
@interface GoodsDetailSection0CollectionViewCell : TUICollectionViewCell<PagePhotosDataSource>{
    UIScrollView *scrollView;

}
@property (strong, nonatomic) GOODS *goods;

@end
