//
//  CheckoutViewController.h
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutTableViewCellHeader.h"
#import "CheckoutTableViewCellFooter.h"
#import "CheckoutTableViewCell.h"
#import "Cart.h"
#import "UserBackend.h"
#import "PaymentViewController.h"
#import "AddressListViewController.h"
#import "OrderBackend.h"
#import "CouponController.h"
#import "RegionView.h"
@interface CheckoutViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,AddressListControllerDelegate,CouponControllerDelegate>
{
    NSArray *lastvalues;
    NSString* couponname;
    NSString* couponvalue;
    NSString* totalweight;
    NSString* expressprice;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarContainer;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
//@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UIButton *checkoutBtn;
- (IBAction)checkoutBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *addressContainer;
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//@property (weak, nonatomic) IBOutlet UIView *couponContainer;
//@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UIView *emptyAddressContainer;

@property (strong, nonatomic) OrderBackend *backend;
@property (strong, nonatomic) FILTER *filter;
@property (strong, nonatomic) UserBackend *Userbackend;
@property (strong, nonatomic) Cart *cart;
@property (nonatomic, weak) USER *user;

-(instancetype)initWithExpress:(NSString *)price;
@end
