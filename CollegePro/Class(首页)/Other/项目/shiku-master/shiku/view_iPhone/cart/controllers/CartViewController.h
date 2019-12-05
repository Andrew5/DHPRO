//
//  CartViewController.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartTableViewCell.h"
#import "CartTableViewCellHeader.h"
#import <XZFramework/QCheckBox.h>
#import "Cart.h"
#import "UserBackend.h"
#import "CartBackend.h"
/**
 *  购物车列表
 */

typedef NS_ENUM(NSInteger, FROMViewControllerState) {
    
    FROM_GOODSVC = 1,
    FROM_SEARCHVC = 2,
};

@interface CartViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,CartTableViewCellDelegate,CartTableViewCellHeaderDelegate,UIScrollViewDelegate,QCheckBoxDelegate>
{
    BOOL isAllSelect;
    BOOL issectionSelected;
    BOOL isrowSelected;
    BOOL isScroll;
    UIButton *topRightBtn;
    BOOL isTableCellEdit;
    BOOL isShowBackBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarContainer;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UIButton *checkoutBtn;
@property (nonatomic,assign)FROMViewControllerState fromVCState;
- (IBAction)checkoutBtnTapped:(id)sender;

@property (strong, nonatomic) CartBackend *backend;

@property (strong, nonatomic) USER *user;
@property (strong, nonatomic) QCheckBox *checkbox;
@property (strong, nonatomic) Cart *cart;

-(instancetype)initWithBackBtn;
- (void)setup;
@end
