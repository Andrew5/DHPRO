//
//  AddCarView.h
//  shiku
//
//  Created by Rilakkuma on 15/8/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/TextStepperField.h>

@interface AddCarView : UIView
+(AddCarView *)instanceTextView;
/**
 * 父视图
 */
@property (weak, nonatomic) IBOutlet UIView *vbRootView;
/**
 * 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
/**
 * 库存
 */
@property (weak, nonatomic) IBOutlet UILabel *labelStock;
/**
 * 商品图
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**
 * 关闭按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
/**
 * 购买数量按钮
 */
@property (weak, nonatomic) IBOutlet TextStepperField *textFieldStepper;
/**
 * 确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btnSure;

@end
