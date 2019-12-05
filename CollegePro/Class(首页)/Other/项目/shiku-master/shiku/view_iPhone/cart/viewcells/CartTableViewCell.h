//
//  CartTableViewCell.h
//  btc
//
//  Created by txj on 15/3/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBindableTableViewCell.h"
#import <XZFramework/QCheckBox.h>
#import <XZFramework/TextStepperField.h>

@class CartTableViewCell;
@protocol CartTableViewCellDelegate <NSObject>

@optional
- (void)didCartItemQuantityTaped:(CartTableViewCell *)cell;
- (void)didCartItemTitleTaped:(CartTableViewCell *)cell;
- (void)didCartItemBuy:(CART_GOODS *)item;
//- (void)didCartItemAddLikeList:(CartTableViewCell *)cell;
- (void)didCartItemDrop:(CART_GOODS *)item;
- (void)cartTableViewCell:(CartTableViewCell *)cell
                didSelect:(BOOL)selected;

@end

@interface CartTableViewCell : TUITableViewCell<QCheckBoxDelegate>
@property (nonatomic, strong) id<CartTableViewCellDelegate> delegate;
@property (strong, nonatomic) CART_GOODS *cartItem;

@property (strong, nonatomic) QCheckBox *check3 ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageWidth;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *editIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *editContainer;
@property (weak, nonatomic) IBOutlet TextStepperField *stepperButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *movelikeButton;

- (IBAction)ibStepperDidStep:(TextStepperField *)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContent;
- (IBAction)deleteButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCotent;

- (void)bind;
@end
