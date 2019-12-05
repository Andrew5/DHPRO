//
//  GoodsDetailMenuViewController.h
//  shiku
//
//  Created by txj on 15/5/21.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailMenuHeaderCollectionReusableView.h"
#import "GoodsDetailMenuCollectionViewCell.h"
#import "CartBackend.h"
#import <XZFramework/TextStepperField.h>


@protocol GoodsDetailMenuViewControllerDelegate <NSObject>
-(void)hideFinished;
-(void)didAddToCartSuccessWithGoodsNum:(NSInteger)num;
@end
/**
 *  商品属性弹出菜单
 */
@interface GoodsDetailMenuViewController : TBaseUIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *words;
    CATEGORY* currentSelectCategory;
    NSInteger goodsNum;
    BOOL canSubmit;
    NSInteger stocks;

}
/**
 * 购物车 通知信息
 */

@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, assign) UIView *shrunkView;
@property (nonatomic, strong) id<GoodsDetailMenuViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stocksLabel;//库存
@property (weak, nonatomic) IBOutlet UIButton *buttomBtn;

@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic, strong) IBOutlet UIView *containerView;//加入购物车 立即购买 界面
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;//关闭小界面🔘

@property (nonatomic, strong) IBOutlet  UICollectionView *collectionView;//产品规格
@property (weak, nonatomic) IBOutlet TextStepperField *stepperButton;//购买数量


@property (nonatomic, strong) GOODS *goods;
@property (nonatomic, strong) CartBackend *backend;

@property (weak, nonatomic) IBOutlet UIView *modalView2;
- (IBAction)textSteperTapped:(id)sender;

- (void) showInView:(UIView*)view;
- (id)initWithGoods:(GOODS *) anGoods;
@end
