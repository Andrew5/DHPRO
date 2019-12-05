//
//  CategoryViewController.h
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBaseUIViewController.h"
#import "CategoryViewCL1CollectionViewCell.h"
#import "CategoryViewCL2CollectionViewCell.h"
#import "CateBackend.h"
#import "SearchViewController.h"
/**
 *  分类页面
 */
@interface CategoryViewController : TBaseUIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CategoryViewCL1CollectionViewCell *firstcell;
    BOOL hasSelect;
    BOOL isShowBackBtn;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView1;//一级目录
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;//二级目录

@property (strong, nonatomic) NSMutableArray* datalist1;
@property (strong, nonatomic) NSArray* datalist2;
@property (strong, nonatomic) CateBackend* backend;
/**
 *  如果是弹出的页面调用此方法初始化
 *
 */
-(instancetype)initWithBackBtn;
@end
