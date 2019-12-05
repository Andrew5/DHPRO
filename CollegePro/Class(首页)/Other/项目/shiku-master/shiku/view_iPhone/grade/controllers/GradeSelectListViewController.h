//
//  GradeViewController.h
//  shiku
//
//  Created by txj on 15/5/25.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeCollectionV2ViewCell.h"
#import "GradeHeaderCollectionReusableView.h"
#import "UserBackend.h"
/**
 *  选择喜欢的品位
 */
@interface GradeSelectListViewController : TBaseUIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL isShowBackBtn;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray* datalist;
@property (strong, nonatomic) UserBackend *backend;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnTapped:(id)sender;
@property (nonatomic, weak) USER *user;
/**
 *  根据品位的列表初始化
 *
 */
-(instancetype)initWithGradeList:(NSArray*)anList;
@end
