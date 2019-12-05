//
//  AddressEdiViewController.h
//  shiku
//
//  Created by yanglele on 15/8/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBackend.h"
#import <XZFramework/TAreaPickerView.h>
@class AddressEditViewController;
@protocol AddressEdiControllerDelegate <NSObject>

@optional
- (void)didAddressUpdate:(ADDRESS *)address controller:(AddressEditViewController *)controller msg:(NSString *)msg;
@end
@interface AddressEdiViewController :TBaseUIViewController
<UITableViewDelegate, UITableViewDataSource, TAreaPickerDelegate,UITextFieldDelegate>
{
    BOOL isedit;
    TAreaPickerView  *locatePicker;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong ,nonatomic) UITableView * TableView;

@property (strong ,nonatomic) UIButton * deletwBtn;
//- (IBAction)deleteBtnTapped:(id)sender;
/**
 *  通过已知地址初始化
 *
 */
-(id)initWithAddress:(ADDRESS *)address;
@property (strong, nonatomic) id<AddressEdiControllerDelegate> delegate;
@property (strong, nonatomic) UITextField *tfName;
@property (strong, nonatomic) UITextField *tfTell;
@property (strong, nonatomic) UITextField *tfArea;
@property (strong, nonatomic) UITextField *tfDesc;
@property (strong, nonatomic) UITextField *tfZipCode;
@property (strong, nonatomic) ADDRESS *address;
@property (strong, nonatomic) UserBackend *backend;
@end
