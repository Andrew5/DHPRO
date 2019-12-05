//
//  CartTableViewCell.m
//  btc
//
//  Created by txj on 15/3/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CartTableViewCell.h"

@implementation CartTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _check3 = [[QCheckBox alloc] initWithDelegate:self checkBoxIconSize:25];
    _check3.frame = CGRectMake(10, 30, 25, 25);
    [_check3 setImage:[UIImage imageNamed:@"icon1_03"] forState:UIControlStateNormal];
    [_check3 setImage:[UIImage imageNamed:@"icon1_10"] forState:UIControlStateSelected];
    _check3.delegate = self;
    [self addSubview:_check3];
    [_check3 setChecked:NO];


    self.coverImageWidth.constant = self.coverImage.frame.size.height * coverimagewidth;
    self.titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCartItemTitleTaped)];
    [self.titleLabel addGestureRecognizer:tapGesture];

    self.quantityLabel.textColor = TEXT_COLOR_DARK;
    self.subTitleLabel.textColor = TEXT_COLOR_DARK;
    self.movelikeButton.layer.cornerRadius = 5;
    [self.movelikeButton setTitle:@"移入喜欢" forState:(UIControlStateNormal)];
    [self.movelikeButton addTarget:self action:@selector(addLikeList) forControlEvents:UIControlEventTouchUpInside];
    self.movelikeButton.titleLabel.numberOfLines=3;
    
    self.deleteButton.layer.cornerRadius = 5;
    self.stepperButton.IsEditableTextField = FALSE;

}
- (void)addLikeList
{
    SEL selector = @selector(didCartItemBuy:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate didCartItemBuy:self.cartItem];
    }
}
- (void)didCartItemTitleTaped {
    SEL selector = @selector(didCartItemTitleTaped:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate didCartItemTitleTaped:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)ibStepperDidStep:(TextStepperField *)sender; {

    if (self.stepperButton.TypeChange == TextStepperFieldChangeKindNegative) {
 
        self.cartItem.goods_number--;
    }
    else {
        self.cartItem.goods_number++;
    }
    SEL selector = @selector(didCartItemQuantityTaped:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate didCartItemQuantityTaped:self];
    }
}

- (IBAction)deleteButtonTapped:(id)sender {
    SEL selector = @selector(didCartItemDrop:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate didCartItemDrop:self.cartItem];
    }

}
- (IBAction)likeButtonTapped:(id)sender {
    
}

- (void)bind {
    @weakify(self)
    [RACObserve(self, cartItem)
            subscribeNext:^(id x) {
                @strongify(self);
                [self render];
            }];
    [RACObserve(self.cartItem, isSeleced)
            subscribeNext:^(id x) {
                @strongify(self);
                self.check3.checked = self.cartItem.isSeleced;
            }];
}

- (void)unbind {
}

- (void)render {
    self.titleLabel.text = self.cartItem.goods_name;

    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.cartItem.goods_price];
    self.check3.checked = self.cartItem.isSeleced;

    self.quantityLabel.text = [NSString stringWithFormat:@"x%ld", (long) self.cartItem.goods_number];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.cartItem.img.small] placeholderImage:img_placehold];

    self.subTitleLabel.text = [NSString stringWithFormat:@"规格：%@", !self.cartItem.goods_strattr ? self.cartItem.goods_strattr : @"默认"];

    if (self.cartItem.isInEditMode) {
        self.stepperButton.Current = self.cartItem.goods_number;
        self.stepperButton.Step = 1;
        self.stepperButton.Minimum = 1;
        self.stepperButton.Maximum = 40;
        self.stepperButton.NumDecimals = 0;
        [self.editContainer setHidden:NO];
        CGRect rect = self.stepperButton.frame;
        NSArray *views = self.stepperButton.subviews;
        NSLog(@"%@",views);
        UIButton *minusBtn = (UIButton*)views[1];
        minusBtn.frame = CGRectMake(0, 0, rect.size.width/3,rect.size.height);
        UITextField *text = (UITextField*)views[3];
        text.frame = CGRectMake(rect.size.width/3,0, rect.size.width/3, rect.size.height);
        UIButton *addBtn = (UIButton*)views[2];
        addBtn.frame = CGRectMake(rect.size.width*2/3,0, rect.size.width/3, rect.size.height);
        UIImageView *imageView = (UIImageView*)views[0];
        imageView.frame = CGRectMake(rect.size.width/3+1, 0,rect.size.width/3-1,rect.size.height);
        if (IPHONE_5||IPHONE_4) {
            self.leftCotent.constant = 2;
            self.rightContent.constant = 2;
        }
        else if (IPHONE_6) {
            self.leftCotent.constant = 10;
            self.rightContent.constant = 10;
        }else
        {
            self.leftCotent.constant = 15;
            self.rightContent.constant = 15;
        }
    }
    else {
        [self.editContainer setHidden:YES];
    }
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    SEL selector = @selector(cartTableViewCell:didSelect:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate cartTableViewCell:self didSelect:checked];
    }
}

@end
