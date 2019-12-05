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
#import "GradeSelectListViewController.h"
/**
 *  品位信息
 */
@interface GradeViewController : TBaseUIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL isShowBackBtn;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray* datalist;
@property (strong, nonatomic) UserBackend *backend;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnTapped:(id)sender;
@property (nonatomic, weak) USER *user;
@end
