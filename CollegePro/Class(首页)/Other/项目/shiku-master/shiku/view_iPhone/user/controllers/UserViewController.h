//
//  UserViewController.h
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBaseUIViewController.h"
#import "UserLoginViewController.h"
#import "UserLikeViewController.h"
#import "AddressListViewController.h"
#import "FavViewController.h"
#import "UserSettingViewController.h"
#import "OrderListViewController.h"
#import "UserBackend.h"
#import "SearchViewController.h"
#import "GradeViewController.h"

#import "STWordAndPhraseView.h"
@interface UserViewController : TBaseUIViewController<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UserLoginViewControllerDelegate>
{
    NSArray *section1icons;
    NSArray *section1titles;
    NSArray *section2icons;
    NSArray *section2titles;
    NSArray *section2values;
    NSArray *section3icons;
    NSArray *section3titles;
    BOOL ISLoadedUserInfo;
    
    UILabel *lbCartBadge;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageHiddenView;

/**
 *  各属性请对照.xib文件
 */
@property (weak, nonatomic) IBOutlet UIView *vbackgroundheader;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UIView *hiddenView;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *headerUserDescCollectionview;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView3;
@property (weak, nonatomic) IBOutlet UIView *emptyUserContainer;
@property (strong, nonatomic)STWordAndPhraseView *STWordView;

/**
 * 关注
 */
@property (weak, nonatomic) IBOutlet UILabel *labelAttention;
/**
 * 喜欢
 */
@property (weak, nonatomic) IBOutlet UILabel *labelLike;
/**
 * 优惠券
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPreferential;


@property (strong, nonatomic) USER *user;
@property (strong, nonatomic) UserBackend *backend;

-(void)authencateUserSuccess:(USER *)user authController:(UserLoginViewController *)controller;
@end
