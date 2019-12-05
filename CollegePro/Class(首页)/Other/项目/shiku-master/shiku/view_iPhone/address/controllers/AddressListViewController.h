//
//  AddressLIstViewController.h
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressTableViewCell.h"
#import "UserBackend.h"
#import "AddressEdiViewController.h"
/**
 *  收货地址
 */
@protocol AddressListControllerDelegate <NSObject>
@optional
- (void)didAddressSelected:(ADDRESS *)address;
@end

@interface AddressListViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,AddressEdiControllerDelegate,SWTableViewCellDelegate>
{
    UIButton *topRightBtn;
}
@property (nonatomic, strong) id<AddressListControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//新增地址按钮
@property (weak, nonatomic) IBOutlet UIButton *addNewAddressBtn;
@property    int initType;

- (IBAction)addNewAddrBtnTapped:(id)sender;

@property (strong, nonatomic) NSMutableArray* address_list;//ADDRESS

@property (strong, nonatomic) UserBackend *backend;
@property (strong, nonatomic) FILTER *filter;
@property (nonatomic, weak) USER *user;

/**
 *  从订单初始化
 *
 *
 */
-(instancetype)initWithCheckOut;

@end
