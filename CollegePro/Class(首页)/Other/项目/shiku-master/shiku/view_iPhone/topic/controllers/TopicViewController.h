//
//  GradeViewController.h
//  shiku
//
//  Created by txj on 15/5/25.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicSection1CollectionViewCell.h"
#import "TopicSection0CollectionViewCell.h"
#import "TopicBackend.h"
#import "GoodsDetailViewController.h"
/**
 *  新品推荐的内容
 */
@interface TopicViewController : TBaseUIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL isShowBackBtn;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray* datalist;
@property (strong, nonatomic) CATEGORY* topicItem;
@property (strong, nonatomic) TopicBackend *backend;
@property (nonatomic, weak) USER *user;
@end
