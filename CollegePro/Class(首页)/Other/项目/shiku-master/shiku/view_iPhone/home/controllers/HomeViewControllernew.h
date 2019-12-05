//
//  HomeViewControllernew.h
//  shiku
//
//  Created by Rilakkuma on 15/7/23.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomeSectionOneVCTableViewCell.h"
//#import "HomeSectionTwoVCTableViewCell.h"
//#import "HomeBtnTableViewCell.h"
//#import "HomeSectionThreeVCTableViewCell.h"
#import "HomePeosonInfoViewController.h"
#import "HomeGetdata.h"//数据类
#import <XZFramework/TextStepperField.h>


// 配置列表
#import "HomeOneTableViewCell.h"
#import "HomeTwoTableViewCell.h"
#import "HomeThreeTableViewCell.h"
#import "HomeFourTableViewCell.h"
//
#import "DKCarouselView.h"


#import "DKFilterView.h"
#import "DKFilterModel.h"

#import "GoodsDetailViewController.h"

@interface HomeViewControllernew : TBaseUIViewController<UISearchBarDelegate
,UIAlertViewDelegate,UIGestureRecognizerDelegate,DKFilterViewDelegate,UserLoginViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UITextFieldDelegate>{
    NSMutableArray *_attentionList;
    BOOL isAttention;
}
@property(nonatomic, strong) USER *user;

@property (strong,nonatomic)UICollectionView *collectionViewS;



@property (nonatomic, strong) IBOutlet UIView *containerView;//加入购物车 立即购买 界面
@property (nonatomic,strong)UIView *shrunkView;



@property (nonatomic,strong) DKFilterView *filterView;
@property (nonatomic,strong) DKFilterModel *clickModel;
@property (readwrite, nonatomic) HomeGetdata *getDate;

@property (strong, nonatomic) NSMutableArray *imageAray;

@property (copy, nonatomic) NSString *midStr;

/**
 *
 *关注 销量
 */
@property (weak, nonatomic) IBOutlet UILabel *labelAttention;
@property (weak, nonatomic) IBOutlet UILabel *labelSalesVolume;
/**
 *
 *标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/**
 *
 *星
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageStart;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageImage;

@end
