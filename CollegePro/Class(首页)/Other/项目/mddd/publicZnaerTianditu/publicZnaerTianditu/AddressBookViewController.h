//
//  AddressBookViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/25.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressBookView.h"
#import <MessageUI/MFMessageComposeViewController.h>
@interface AddressBookViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>

@property(nonatomic,retain)AddressBookView *addressBookView;

@property(nonatomic,strong)NSMutableArray *contactsArray;

@property(nonatomic,copy)NSMutableArray *sections;

@end
