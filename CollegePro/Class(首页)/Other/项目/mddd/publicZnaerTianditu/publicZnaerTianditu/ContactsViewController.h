//
//  ContactsViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactsView.h"
#import "NewFriendViewController.h"
#import "FriendManagerHandler.h"



@interface ContactsViewController : BaseViewController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>{
    
    UILabel *newFriendLb;
    UIButton *newFriendBtn;
}

@property(nonatomic,strong)ContactsView *contactsView;
@property(nonatomic, strong) NSMutableArray *dataList;//数据
@property(nonatomic, copy) NSArray *filteredList;//查询结果
@property(nonatomic, copy) NSMutableArray *sections;
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController;
@property(nonatomic,strong) FriendManagerHandler *friendHandler;
@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;



- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated; // Implemented by the subclasses

@end
