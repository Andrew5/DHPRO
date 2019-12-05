//
//  HomeViewController.h
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/PagePhotosDataSource.h>
#import <XZFramework/PagePhotosView.h>
#import "HomeSectionHeaderViewCell.h"
#import "AdHeaderCollectionViewCell.h"
#import "HomeSection2CollectionViewCell.h"
#import "HomeSection3CollectionViewCell.h"
#import "HomeSection4CollectionViewCell.h"
#import "HomeSection4TypeTGCollectionViewCell.h"
#import "HomeSection4TypeXLBCollectionViewCell.h"
#import "HomeSection4TypeXSGCollectionViewCell.h"
#import "UDNavigationController.h"
#import "SearchViewController.h"
#import "GoodsListViewController.h"
#import "InformationController.h"
#import <XZFramework/QRCodeReaderViewController.h>
#import "TopicViewController.h"
#import "HomeBackend.h"
/**
 *  首页
 */
@interface HomeViewController : TBaseUIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AdHeaderCollectionViewCellDelegate,UIScrollViewDelegate,QRCodeReaderDelegate>
{
    UDNavigationController *nav;
    CGFloat pointX;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margLeft;
@property (strong, nonatomic) HomeBackend *backend;
@property (strong, nonatomic) HomeItems *homeItem;
@property (strong, nonatomic) UICollectionView *collectionView;

@end
